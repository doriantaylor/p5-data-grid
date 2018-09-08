package Data::Grid::Table;

use 5.012;
use strict;
use warnings FATAL => 'all';

use Moo;

use overload '<>'  => "next";
use overload '@{}' => "rows";

use Types::Standard qw(Int);

extends 'Data::Grid::Container';

=head1 NAME

Data::Grid::Table - A table implementation for Data::Grid

=head1 VERSION

Version 0.02_01

=cut

our $VERSION = '0.02_01';

has marker => (
    is       => 'rwp',
    isa      => Int,
    default  => 0,
    init_arg => undef,
);

=head1 SYNOPSIS

    my $grid = Data::Grid->parse('arbitrary.csv');

    # Just take the first one, since a CSV will only have one table.
    my ($table) = $grid->tables;

    while (my $row = $table->next) {
        # do some stuff
    }

    # or

    while (my $row = <$table>) {
        # ...
    }

    # or

    my @rows = $table->rows;

    # or

    my @rows = @$table;

=head1 METHODS

=head2 next

Retrieves the next row in the table or C<undef> when it reaches the
end. This method L<must be overridden> by a driver subclass. The
iteration operator C<<>> is also overloaded for table objects, so you
can use it like this:

    while (my $row = <$table>) { ...

=cut

sub next {
    Carp::croak("This method is a stub; it must be overridden!");
}

=head2 first

Returns the first row in the table, and is equivalent to calling
L</rewind> and then L</next>.

=cut

sub first {
    my $self = shift;
    $self->rewind;
    $self->next;
}

=head2 rewind

Sets the table's cursor back to the first row. Returns the previous
position, beginning at zero. This method I<must be overridden> by a
driver subclass.

=cut

sub rewind {
    Carp::croak("This method is a stub; it must be overridden!");
}

=head2 rows

Retrieves an array of rows all at once, or if taken in scalar context,
an array reference. This method overloads the array dereferencing
operator C<@{}>, so you can use it like this:

    my @rows = @$table;

=cut

sub rows {
    my ($self, @rows) = @_;
    #my @rows;

    $self->rewind;
    while (my $row = $self->next) {
        push @rows, $row;
    }
    $self->rewind;

    wantarray ? @rows : \@rows;
}

=head2 columns

=cut

sub columns {
    $_[0]->parent->columns;
}

=head2 width

Gets the width, in columns, of the table.

=cut

=head2 height

Gets the height, in rows, of the table. Careful, for drivers that only
do sequential access, this means iterating over the whole set, so you
might as well.

=cut

sub height {
    scalar @{$_[0]->rows};
}

=head2 as_string

Serializes the table into a string and returns the result. Currently
unimplemented.

=cut

sub as_string {
    my $self = shift;
}

#sub as_string {
#    
#}

=head2 as_data_table

Returns a new Data::Table object for compatibility.

=cut

sub as_data_table {
    require Data::Table;
}

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 SEE ALSO

=over 4

=item

L<Data::Grid>

=item

L<Data::Grid::Container>

=item

L<Data::Grid::Row>

=item

L<Data::Grid::Cell>

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

1; # End of Data::Grid::Table
