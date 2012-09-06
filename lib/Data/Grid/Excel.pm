package Data::Grid::Excel;

use warnings FATAL => 'all';
use strict;

use base 'Data::Grid';

use Spreadsheet::ParseExcel;

=head1 NAME

Data::Grid::Excel - Excel driver for Data::Grid

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';

=head1 METHODS

=head2 new

=cut

sub new {
    my $class = shift;
    my %p = @_;
    $p{driver} = Spreadsheet::ParseExcel->new;
    $p{proxy}  = $p{driver}->parse($p{fh}) or die $p{driver}->error;
    bless \%p, $class;
}

=head2 tables

=cut

sub tables {
    my $self = shift;
    my $counter = 0;
    my @tables;
    for my $sheet ($self->{proxy}->worksheets) {
        push @tables, $self->table_class->new($self, $counter++, $sheet);
    }
    wantarray ? @tables : \@tables;
}

=head2 table_class

=cut

sub table_class {
    'Data::Grid::Excel::Table';
}

=head2 row_class

=cut

sub row_class {
    'Data::Grid::Excel::Row';
}

=head2 cell_class

=cut

sub cell_class {
    'Data::Grid::Excel::Cell';
}

package Data::Grid::Excel::Table;

use base 'Data::Grid::Table';

sub rewind {
    $_[0]->{counter} = 0;
}

sub next {
    my $self = shift;
    $self->{counter} ||= 0;
    my ($minr, $maxr) = $self->proxy->row_range;
    #my ($minc, $maxc) = $self->proxy->col_range;

    if ($maxr - $minr > 0 and $self->{counter} + $minr <= $maxr) {
        #warn "yooo";
        #warn $self->parent->row_class;
        return $self->parent->row_class->new
            ($self, $self->{counter}, $minr + $self->{counter}++);
    }
    return;
}

package Data::Grid::Excel::Row;

use base 'Data::Grid::Row';

sub cells {
    my $self = shift;
    my ($minc, $maxc) = $self->parent->proxy->col_range;
    #warn "$minc $maxc";
    my @cells;
    #warn $self->parent->parent->cell_class;
    for (my $c = 0; $c <= $maxc - $minc; $c++) {
        push @cells, $self->parent->parent->cell_class->new
            ($self, $c, $self->parent->proxy->get_cell($self->proxy, $c));
    }
    wantarray ? @cells : \@cells;
}

package Data::Grid::Excel::Cell;

use base 'Data::Grid::Cell';

sub value {
    $_[0]->proxy->value if defined $_[0]->proxy;
}

sub literal {
    $_[0]->proxy->unformatted if defined $_[0]->proxy;
}

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
