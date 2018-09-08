package Data::Grid::Types;

use 5.012;
use strict;
use warnings FATAL => 'all';

use Type::Library -base, -declare => qw(FHlike Source Fields HeaderFlags);
use Type::Utils -all;
use Types::Standard
    qw(Maybe Any Value Bool Str ScalarRef ArrayRef GlobRef Object InstanceOf);

our $VERSION = '0.02_01';

=head1 NAME

Data::Grid::Types - Type library for Data::Grid

=head1 TYPES

So far these are only used in L<Data::Grid/parse> and nowhere else.

=head2 FHlike

Either a filehandle or an instance of L<IO::Seekable>.

=cut

subtype FHlike, as GlobRef|InstanceOf['IO::Seekable'];

=head2 Source

Anything that can be recognized as a data source.

=cut

subtype Source, as Str|FHlike|ScalarRef[Value]|ArrayRef[Maybe[Value|Object]];

=head2 Fields

An array reference of array references of strings to for row hash
constructors for each table. Will coerce from a single array.

=cut

subtype Fields, as ArrayRef[ArrayRef[Str]];
coerce Fields, from ArrayRef[Value|Object], via { [$_] };

=head2 HeaderFlags

Similar idea, except for the flag that notifies of the existence of a
header. Coerces from a single value.

=cut

subtype HeaderFlags, as ArrayRef[Bool];
coerce HeaderFlags, from ArrayRef[Any], via { [map { !!$_ } @{$_}] };
coerce HeaderFlags, from Maybe[Value],  via { [!!$_] };

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

1;
