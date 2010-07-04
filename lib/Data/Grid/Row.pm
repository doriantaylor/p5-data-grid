package Data::Grid::Row;

use warnings FATAL => 'all';
use strict;

use base 'Data::Grid::Container';

use overload '@{}' => "cells";
use overload '%{}' => "as_hash";

=head1 NAME

Data::Grid::Row - Row implementation for Data::Grid::Table

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';

=head1 SYNOPSIS

    # CSV files are themselves only a single table, so the list
    # context assignment here takes the first and only one.
    my ($table) = Data::Grid->parse('foo.csv')->tables;

    while (my $row = $table->next) {
        my @cells = $row->cells;
        # or
        @cells = @$row;

        # or, if column names were supplied somehow:

        my %cells = $row->as_hash;
        # or
        %cells = %$row;
    }

=head1 METHODS

=head2 table

Retrieve the L<Data::Grid::Table> object to which this row
belongs. Alias for L<Data::Grid::Container/parent>.

=cut

sub table {
    $_[0]->parent;
}

=head2 cells

Retrieve the cells from the row, as an array in list context or
arrayref in scalar context. The array dereferencing operator C<@{}> is
also overloaded and works like this:

    my @cells = @$row;

=cut

sub cells {
    Carp::croak("This method is a stub; it must be overridden!");
}

=head2 as_hash

If the table has a heading or its columns were designated in the
constructor or with L<Data::Grid::Table/columns>, this method will
return the row as key-value pairs in list context and a HASH reference
in scalar context. If there is no column spec, this method will
generate dummy column names starting from 1, like C<col1>, C<col2>,
etc. It will also fill in the blanks if the column spec is shorter
than the actual row. If the column spec is longer, the overhang will
be populated with C<undef>s. As well it is worth noting that duplicate
keys will be clobbered with the rightmost value at this time, though
that behaviour may change. As with the other pertinent methods, the
hash dereference operator C<%{}> is overloaded and will behave as
such:

    my %cells = %$row;

=cut

sub as_hash {
    my $self = shift;
#    my @cols = $self->table->columns or Carp::croak(
#        q{Can't make a hash of cells. The table must have a heading or },
#        q{the columns must be specified either in the constructor or by },
#        q{setting them with "columns" in Data::Grid::Table.});
#    my @cells = $self->cells;
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

    perldoc Data::Grid::Row


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
L<Data::Grid::Cell>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Dorian Taylor.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Data::Grid::Row
