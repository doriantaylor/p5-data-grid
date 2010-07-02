package Data::Grid::Excel;

use warnings FATAL => 'all';
use strict;

use base 'Data::Grid';

=head1 NAME

Data::Grid::Excel - Excel driver for Data::Grid

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';

=head1 METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

package Data::Grid::Excel::XLS;

our @ISA = qw(Data::Grid::Excel);

sub new {
    require Spreadsheet::ParseExcel;
}

package Data::Grid::Excel::XLSX;

our @ISA = qw(Data::Grid::Excel);

sub new {
    require Spreadsheet::XLSX;
}

package Data::Grid::Excel::Table;

use base 'Data::Grid::Table';

package Data::Grid::Excel::Row;

use base 'Data::Grid::Row';

package Data::Grid::Excel::Cell;

use base 'Data::Grid::Cell';

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-grid at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Grid>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Grid::Excel


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


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Dorian Taylor.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Data::Grid::Excel
