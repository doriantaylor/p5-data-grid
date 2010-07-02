package Data::Grid::CSV;

use warnings FATAL => 'all';
use strict;

use base 'Data::Grid';

use Text::CSV;
use IO::File;

=head1 NAME

Data::Grid::CSV - CSV driver for Data::Grid

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';

sub new {
    my $class = shift;
}


package Data::Grid::CSV::Table;

use base 'Data::Grid::Table';

sub rewind {
    my $self = shift;
    $self->{parent}{fh}->setpos(0);
}

sub next {
    my $self = shift;
    $self->{proxy}->getline($self->{parent}{fh});
}

package Data::Grid::CSV::Row;

use base 'Data::Grid::Row';

package Data::Grid::CSV::Cell;

use base 'Data::Grid::Cell';

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-grid at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Grid>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Grid::CSV

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

1; # End of Data::Grid::CSV
