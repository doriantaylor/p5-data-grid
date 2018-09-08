#!perl -T

use strict;
use warnings;
use Test::More;

my @TEST = (
    [CSV   => qw(data-grid-sample.csv CSV::Table CSV::Row CSV::Cell)],
    [Excel => qw(data-grid-sample.xls Excel::Table Excel::Row Excel::Cell)],
    ['Excel::XLSX'
        => qw(data-grid-sample.xlsx Excel::Table Excel::Row Excel::Cell)],
);

plan tests => @TEST * 5 + 1;

use_ok('Data::Grid');

for my $testdata (@TEST) {
    my ($class, $file, $tclass, $rclass, $cclass) = @$testdata;

    my $full = "Data::Grid::$class";
    my $path = "t/$file";

    diag($path);
    my $grid = Data::Grid->parse($path);

    isa_ok($grid, $full, "$class instance");

    $grid = Data::Grid->parse(source => $path, checker => 'MimeInfo');
    isa_ok($grid, $full, "static check with mimeinfo");

    open my $fh, $path or die $!;

    $grid = Data::Grid->parse(source => $fh);
    isa_ok($grid, $full, 'content check, MMagic');

    $grid = Data::Grid->parse(source => $fh, checker => 'MimeInfo');
    isa_ok($grid, $full, 'content check, MimeInfo');

    my @tables = $grid->tables;

    is(scalar @tables, 1, 'one table in the test document');

    while (my $row = $tables[0]->next) {
        diag $row;
    }
}
