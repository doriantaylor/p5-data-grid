package Data::Grid::Table;

use warnings FATAL => 'all';
use strict;

use base 'Data::Grid::Container';

use overload '<>'  => "next";
use overload '@{}' => "rows";

=head1 NAME

Data::Grid::Table - A table implementation for Data::Grid

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';


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

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-grid at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Grid>.  I will
be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Grid::Table

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

L<Data::Grid>, L<Data::Grid::Container>, L<Data::Grid::Row>,
L<Data::Grid::Cell>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Dorian Taylor.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Data::Grid::Table
