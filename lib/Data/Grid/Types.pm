package Data::Grid::Types;

use strict;
use warnings FATAL => 'all';

use Type::Library -base, -declare => qw(Source Fields HeaderFlags);
use Type::Utils -all;
use Types::Standard
    qw(Maybe Any Value Bool Str ScalarRef ArrayRef GlobRef Object InstanceOf);

=head1 NAME

Data::Grid::Types - Type library for Data::Grid

=head1 TYPES

=head2 Source

=cut

subtype Source, as Str|GlobRef|InstanceOf['IO::Seekable']|ScalarRef[Value]
    |ArrayRef[Maybe[Value|Object]];

=head2 Fields

=cut

subtype Fields, as ArrayRef[ArrayRef[Str]];
coerce Fields, from ArrayRef[Value|Object], via { [$_] };

=head2 HeaderFlags

=cut

subtype HeaderFlags, as ArrayRef[Bool];
coerce HeaderFlags, from ArrayRef[Any], via { [map { !!$_ } @{$_}] };
coerce HeaderFlags, from Maybe[Value],  via { [!!$_] };

1;
