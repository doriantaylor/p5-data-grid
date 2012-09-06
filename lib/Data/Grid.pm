package Data::Grid;

use warnings FATAL => 'all';
use strict;

use File::MMagic ();
use IO::File     ();
use IO::Scalar   ();
use Scalar::Util ();

#use overload '@{}' => 'tables';

my %MAP = (
    'application/octet-stream' => 'Data::Grid::Excel',
    'application/msword'       => 'Data::Grid::Excel',
    'application/excel'        => 'Data::Grid::Excel',
    'application/x-zip'        => 'Data::Grid::Excel::XLSX',
    'text/plain'               => 'Data::Grid::CSV',
    'text/csv'                 => 'Data::Grid::CSV',
);

=head1 NAME

Data::Grid - Incremental read-only (for now) access to grid-based data

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';

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

=cut

sub parse {
    my $class = shift;
    my %p;
    if (@_ == 1) {
        $p{source} = shift;
    }
    else {
        %p = @_;
    }

    # croak unless source is defined
    Carp::croak("I can't do any work unless you specify a data source.")
          unless defined $p{source};

    if (ref $p{source}) {
        # if it is a reference, it depends on the kind
        if (ref $p{source} eq 'SCALAR') {
            # scalar ref as a literal
            $p{fh} = IO::Scalar->new($p{source});
        }
        elsif (ref $p{source} eq 'ARRAY') {
            # array ref as a list of lines
        }
        elsif (ref $p{source} eq 'GLOB' or Scalar::Util::blessed($p{source})
                   && $p{source}->isa('IO::Seekable')) {
            # ioref as just a straight fh
            $p{fh} = $p{source};
        }
        else {
            # dunno
        }
    }
    else {
        # if it is a string, it is assumed to be a filename
        $p{fh} = IO::File->new($p{source}) or Carp::croak($!);
    }
    binmode $p{fh};
    # now check mime type
    my $magic = File::MMagic->new;
    my $type  = $magic->checktype_filehandle($p{fh});
    seek $p{fh}, 0, 0;
    Carp::croak("There is no driver mapped to $type") unless $MAP{$type};
    eval "require $MAP{$type};" or die;
#        or die "Type $type points to driver $MAP{$type} which is broken or nonexistent";
    $MAP{$type}->new(%p);
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

=cut

sub new {
}

=head2 table_class

Returns the class to use for instantiating tables. Defaults to
L<Data::Grid::Table>, which is an abstract class. Override this method
with your own value for extensions.

=cut

sub table_class {
    'Data::Grid::Table';
}

=head2 row_class

Returns the class to use for instantiating rows. Defaults to
L<Data::Grid::Row>.

=cut

sub row_class {
    'Data::Grid::Row';
}

=head2 cell_class

Returns the class to use for instantiating cells. Defaults to
L<Data::Grid::Cell>, again an abstract class.

=cut

sub cell_class {
    'Data::Grid::Cell';
}

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

L<Text::CSV_XS>, L<Spreadsheet::ReadExcel>, L<Spreadsheet::XLSX>,
L<Data::Table>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Dorian Taylor.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License.  You may
obtain a copy of the License at
L<http://www.apache.org/licenses/LICENSE-2.0>.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.

=cut

1; # End of Data::Grid
