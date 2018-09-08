package Data::Grid;

use 5.012;
use strict;
use warnings FATAL => 'all';

use Scalar::Util ();

# module-loading paraphernalia
use String::RewritePrefix ();
use Class::Load           ();

use Moo;
use Data::Grid::Types qw(FHlike Source Fields HeaderFlags);
use Type::Params qw(compile multisig Invocant);
use Types::Standard qw(slurpy Optional ClassName Any Bool
                       Str ScalarRef HashRef Enum Dict);

#use overload '@{}' => 'tables';

# store it this way then flip it around

my %MAP = (
    CSV   => [qw(text/plain text/csv)],
    Excel => [qw(application/x-ole-storage application/vnd.ms-excel
                 application/msword application/excel)],
    'Excel::XLSX' => [
        qw(application/x-zip application/x-zip-compressed application/zip
           application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)],
);
%MAP = map { my $k = $_; my @x = @{$MAP{$k}}; map { $_ => $k } @x } keys %MAP;

=head1 NAME

Data::Grid - Incremental read access to grid-based data

=head1 VERSION

Version 0.02_01

=cut

our $VERSION = '0.02_01';

=head1 SYNOPSIS

    use Data::Grid;

    # Have the parser guess the kind of file, using defaults.

    my $grid = Data::Grid->parse('arbitrary.xls');

    # or

    my $grid = Data::Grid->parse(
        source  => 'arbitrary.csv', # or xls, or xlsx, or filehandle...
        header  => 1,               # first line is a header everywhere
        fields  => [qw(a b c)],     # override field header
        options => \%options,       # driver-specific options
    );

    # Each object contains one or more tables.

    for my $table ($grid->tables) {

        # Each table has one or more rows.

        while (my $row = $table->next) {

            # The columns can be dereferenced as an array,

            my @cols = @$row; # or just $row->columns

            # or, if header is present or fields were named in the
            # constructor, as a hash.

            my %cols = %$row;

            # Now we can do stuff.
        }
    }

=head1 DESCRIPTION

=over 4

=item Problem 1

You have a mountain of data files from two decades of using MS Office
(and other) products, and you want to collate their contents into
someplace sane.

=item Problem 2

The files are in numerous different formats, and a consistent
interface would really cut down on the effort of extracting them.

=item Problem 3

You've looked at L<Data::Table> and L<Spreadsheet::Read>, but deemed
their table-at-a-time strategy to be inappropriate for your purposes.

=back

The goal of L<Data::Grid> is to provide an extensible, uniform,
object-oriented interface to all kinds of grid-shaped data. A key
behaviour I'm after is to perform an incremental read over a
potentially large data source, so as not to unnecessarily gobble up
system resources.

=head1 DEVELOPER RELEASE

Odds are I will probably decide to change the interface at some point
before locking in, and I don't want to guarantee consistency yet. If I
do, and you use this, your code will probably break.

Suffice to say this module is B<ALPHA QUALITY> at best.

=head1 METHODS

=head2 parse $file | %params

The principal way to instantiate a L<Data::Grid> object is through the
C<parse> factory method. This method detects

=over 4

=item source

This is equivalent to C<$file>.

=item header
 
=item fields

=item options

=item driver

=item checker

=back

=cut


my %CHECK = (
    MMagic => [
        # filename-based
        sub { File::MMagic->new->checktype_filename(shift) },
        # fh-based
        sub { File::MMagic->new->checktype_filehandle(shift) },
    ],
    MimeInfo => [
        # filename-based
        sub { File::MimeInfo::mimetype(shift) },
        # fh-based
        sub {
            require File::MimeInfo::Magic;
            File::MimeInfo::Magic::mimetype(shift);
        },
    ],
);

has fh => (
    is       => 'ro',
    isa      => FHlike,
    required => 1,
    init_arg => 'fh',
);

sub parse {
    state $check = Type::Params::multisig(
        [Invocant, Source],
        [Invocant, slurpy Dict[source  => Source,
                               header  => Optional[HeaderFlags],
                               fields  => Optional[Fields],
                               options => Optional[HashRef],
                               driver  => Optional[ClassName],
                               checker => Optional[Enum['MMagic', 'MimeInfo']],
                               slurpy Any]]
    );

    my ($class, $p) = $check->(@_);
    my %p = ref $p eq 'HASH' ? %$p : (source => $p);

    # croak unless source is defined
    Carp::croak("I can't do any work unless you specify a data source.")
          unless defined $p{source};

    my $ref = ref $p{source};

    if ($ref) {
        # if it is a reference, it depends on the kind
        if ($ref eq 'SCALAR') {
            # scalar ref as a literal
            require IO::Scalar;
            $p{fh} = IO::Scalar->new($p{source});
        }
        elsif ($ref eq 'ARRAY') {
            # array ref as a list of lines
            require IO::ScalarArray;
            $p{fh} = IO::ScalarArray->new($p{source});
        }
        elsif ($ref eq 'GLOB' or Scalar::Util::blessed($p{source})
                   && $p{source}->isa('IO::Seekable')) {
            # ioref as just a straight fh
            $p{fh} = $p{source};
        }
        else {
            # dunno
            Carp::croak("Don't know what to do with $ref as a source.");
        }
    }
    else {
        # if it is a string, it is assumed to be a filename
        require IO::File;
        $p{fh} = IO::File->new($p{source}) or Carp::croak($!);
    }

    # binary this because it gets messed up otherwise
    binmode $p{fh};

    # if you didn't specify a driver we pick one for you
    unless ($p{driver}) {
        $p{checker} ||= 'MMagic';
        Class::Load::try_load_class("File::$p{checker}") or die
              "Install File::$p{checker} to do type detection. See docs.";

        my $type;
        unless ($ref) {
            # check the type by filename
            $type = $CHECK{$p{checker}}[0]->($p{source}) // '';
            # octet-stream is a bad type
            undef $type unless $MAP{$type};
        }

        # now check the filehandle
        unless ($type) {
            $type = $CHECK{$p{checker}}[1]->($p{fh});
            # reset the filehandle
            seek $p{fh}, 0, 0;
        }

        Carp::croak("There is no driver mapped to $type") unless $MAP{$type};

        $p{driver} = $MAP{$type};
    }

    # now load the driver
    (my $driver) = String::RewritePrefix->rewrite
        ({ '' => 'Data::Grid::', '+' => ''}, delete $p{driver});
    Class::Load::load_class($driver);

    $driver->new(%p);
}

=head2 fields

retrieve the fields

=cut

sub fields {
    my $self   = shift;
    my @fields = @{$self->{fields} || []};
    wantarray ? @fields : \@fields;
}

=head2 tables

Retrieve the tables

=cut

sub tables {
}

=head1 EXTENSION INTERFACE

=head2 new

This I<new> is only part of the extension interface. It is a basic
utility constructor intended to take an already-parsed object and
parameters and proxy them.

=head2 table_class

Returns the class to use for instantiating tables. Defaults to
L<Data::Grid::Table>, which is an abstract class. Override this method
with your own value for extensions.

=cut

has table_class => (
    is      => 'ro',
    isa     => ClassName,
    default => 'Data::Grid::Table',
);

=head2 row_class

Returns the class to use for instantiating rows. Defaults to
L<Data::Grid::Row>.

=cut

has row_class => (
    is      => 'ro',
    isa     => ClassName,
    default => 'Data::Grid::Row',
);

=head2 cell_class

Returns the class to use for instantiating cells. Defaults to
L<Data::Grid::Cell>, again an abstract class.

=cut

has cell_class => (
    is      => 'ro',
    isa     => ClassName,
    default => 'Data::Grid::Cell',
);

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-grid at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Grid>.  I will
be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Grid

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Grid>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-Grid>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-Grid>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-Grid/>

=back


=head1 SEE ALSO

=over 4

=item

L<Text::CSV>

=item

L<Spreadsheet::ReadExcel>

=item

L<Spreadsheet::XLSX>

=item

L<Data::Table>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2010-2018 Dorian Taylor.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License. You may
obtain a copy of the License at
L<http://www.apache.org/licenses/LICENSE-2.0>.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.

=cut

1; # End of Data::Grid
