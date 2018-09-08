package Data::Grid::CSV;

use 5.012;
use strict;
use warnings FATAL => 'all';

use Moo;

extends 'Data::Grid';

use Text::CSV;

=head1 NAME

Data::Grid::CSV - CSV driver for Data::Grid

=head1 VERSION

Version 0.02_01

=cut

our $VERSION = '0.02_01';

=head2 new

=cut

has _csv => (
    is       => 'ro',
    required => 1,
);

around BUILDARGS => sub {
    my ($orig, $class, @rest) = @_;

    # normalize the params
    my $p = (@rest && ref $rest[0] eq 'HASH') ? $rest[0] : { @rest };
    my $o = $p->{options} || { binary => 1 };

    # instantiate the csv driver
    $p->{_csv} = Text::CSV->new($o) or die $!;

    $class->$orig($p);
};

=head2 tables

=cut

sub tables {
    my $self = shift;
    #warn @Data::Grid::CSV::Table::ISA;
    my $table = $self->table_class->new($self, 0);
    wantarray ? ($table) : [$table];
}

=head2 table_class

=cut

has '+table_class' => (
    default => 'Data::Grid::CSV::Table',
);

=head2 row_class

=cut

has '+row_class' => (
    default => 'Data::Grid::CSV::Row',
);

=head2 cell_class

=cut

has '+cell_class' => (
    default => 'Data::Grid::CSV::Cell',
);

package Data::Grid::CSV::Table;

use Moo;

extends 'Data::Grid::Table';

sub rewind {
    my $self = shift;
    seek $self->parent->fh, 0, 0;
}

sub next {
    my $self = shift;
    my $p   = $self->parent;
    my $csv = $p->_csv;
    my $row = $csv->getline($p->fh);
    return if !$row and $csv->eof;

    $row ||= [];

    my $marker = $self->marker;
    $self->_set_marker($marker + 1);

    $p->row_class->new($self, $marker, $row);
}

package Data::Grid::CSV::Row;

use Moo;

extends 'Data::Grid::Row';

sub cells {
    my $self = shift;
    my $cls  = $self->parent->parent->cell_class;
    my @cells = @{$self->proxy};
    @cells = map { $cls->new($self, $_, $cells[$_]) } (0..$#cells);

    wantarray ? @cells : \@cells;
}

package Data::Grid::CSV::Cell;

use Moo;

extends 'Data::Grid::Cell';

sub value {
    $_[0]->proxy;
}

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 SEE ALSO

=over 4

=item

L<Data::Grid>

=item

L<Text::CSV_XS>

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

1; # End of Data::Grid::CSV
