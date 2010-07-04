package Data::Grid::Cell;

use warnings FATAL => 'all';
use strict;

use base 'Data::Grid::Container';

use overload '0+'   => 'value';
use overload '""'   => 'value';
use overload 'bool' => 'value';

=head1 NAME

Data::Grid::Cell - Cell implementation for Data::Grid::Row

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';


=head1 SYNOPSIS

    for my $cell (@$cells) {
        warn $cell->value;

        # string overload
        printf "%s\n", $cell;
    }

=head1 METHODS

=head2 value

Retrieves a representation of the value of the cell, potentially
formatted by the source, versus a possible alternate L</literal>
value. This method is a I<stub>, and should be defined in a driver
subclass. If the cell is stringified, compared numerically or tested
for truth, this is the method that is called, like so:

     print "$cell\n"; # stringification overloaded

=cut

sub value {
    Carp::croak("Somebody forgot to override this method.");
}

=head2 literal

Spreadsheets tend to have a literal value underlying a formatted value
in a cell, which is why we have this class and are not just using
scalars to represent cells. If your driver has literal values,
override this method, otherwise it is a no-op.

=cut

sub literal {
    $_[0]->value;
}

=head2 row

Alias for L<Data::Grid::Container/parent>.

=cut

sub row {
    $_[0]->parent;
}

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-grid at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Grid>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Grid::Cell


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

L<Data::Grid>, L<Data::Grid::Container>, L<Data::Grid::Table>,
L<Data::Grid::Row>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Dorian Taylor.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Data::Grid::Cell
