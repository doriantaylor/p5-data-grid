package Data::Grid::Container;

use warnings FATAL => 'all';
use strict;

use Scalar::Util ();
use Carp         ();

use overload '""' => \&as_string;

=head1 NAME

Data::Grid::Container - Generic superclass for Data::Grid containers

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';


=head1 SYNOPSIS

    package Data::Grid::Foo;

    use base 'Data::Grid::Container';

    # Now code some specific stuff...

=head1 DESCRIPTION

The data grid in L<Data::Grid> is modeled as an ordered tree of
tables, rows and cells, all contained inside a bundle. This module
encapsulates the common behaviour of these components.

=head1 METHODS

=head2 new $parent, $position [, $proxy ]

This basic constructor takes three arguments: the parent object, a
numeric position amongst its siblings, beginning with 0, and an
optional proxy object to manipulate directly, if it is necessary or
advantageous to do so.

=cut

sub new {
    my ($class, $parent, $position, $proxy) = @_;
    my $self = bless {
        parent   => $parent,
        position => $position,
        proxy    => $proxy,
    }, $class;
    Scalar::Util::weaken($self->{parent})
          unless Scalar::Util::isweak($self->{parent});
    $self;
}

=head2 parent

Retrieve the parent object.

=cut

sub parent {
   $_[0]->{parent};
}

=head2 position

Retrieve the absolute position of the object, as it was passed in from
the constructor.

=cut

sub position {
    $_[0]->{position};
}

=head2 proxy

Retrieve the proxy object (for internal manipulation).

=cut

sub proxy {
    $_[0]->{proxy};
}

=head2 as_string

This is a I<stub> to hook up a serialization method to the string
overload. Fill it in at your leisure, otherwise it is a no-op.

=cut

sub as_string {
    $_[0];
}

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-grid at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Grid>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Grid::Container


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

L<Data::Grid>, L<Data::Grid::Table>, L<Data::Grid::Row>,
L<Data::Grid::Cell>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Dorian Taylor.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Data::Grid::Row
