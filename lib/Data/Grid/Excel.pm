package Data::Grid::Excel;

use 5.012;
use strict;
use warnings FATAL => 'all';

use Moo;

use Spreadsheet::ParseExcel;
use Carp ();

extends 'Data::Grid';

=head1 NAME

Data::Grid::Excel - Excel (original OLE format) driver for Data::Grid

=head1 VERSION

Version 0.02_01

=cut

our $VERSION = '0.02_01';

=head1 METHODS

=head2 new

=cut

has _proxy => (
    is => 'rwp',
);

sub _init {
    my ($self, $options) = @_;

    my $driver = Spreadsheet::ParseExcel->new(%$options);
    $driver->parse($self->fh) or Carp::croak($driver->error);
}

sub BUILD {
    my ($self, $p) = @_;

    my $options = ref $p->{options} eq 'HASH' ? $p->{options} : {};

    $self->_set__proxy($self->_init($options));
}

=head2 tables

=cut

sub tables {
    my $self = shift;

    my $p   = $self->_proxy;
    my $tc  = $self->table_class;
    my $pos = 0;
    warn $tc;
    my @tables = map { $tc->new($self, $pos++, $_) } $p->worksheets;

    wantarray ? @tables : \@tables;
}

=head2 table_class

=cut

has '+table_class' => (
    default => 'Data::Grid::Excel::Table',
);

=head2 row_class

=cut

has '+row_class' => (
    default => 'Data::Grid::Excel::Row',
);

=head2 cell_class

=cut

has '+cell_class' => (
    default => 'Data::Grid::Excel::Cell',
);

package Data::Grid::Excel::Table;

use Moo;

extends 'Data::Grid::Table';

sub rewind {
    $_[0]->_set_marker(0);
}

sub next {
    my $self = shift;
    my $marker = $self->marker;
    my ($minr, $maxr) = $self->proxy->row_range;
    #my ($minc, $maxc) = $self->proxy->col_range;

    if ($maxr - $minr > 0 and $marker + $minr <= $maxr) {
        #warn "yooo";
        #warn $self->parent->row_class;
        $self->_set_marker($marker + 1);
        return $self->parent->row_class->new($self, $marker, $minr + $marker);
    }
    return;
}

package Data::Grid::Excel::Row;

use Moo;

extends 'Data::Grid::Row';

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

use Moo;

extends 'Data::Grid::Cell';

sub value {
    $_[0]->proxy->value if defined $_[0]->proxy;
}

sub literal {
    $_[0]->proxy->unformatted if defined $_[0]->proxy;
}

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 SEE ALSO

=over 4

=item

L<Data::Grid>

=item

L<Spreadsheet::ReadExcel>

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


1; # End of Data::Grid::Excel
