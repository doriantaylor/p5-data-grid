#!perl -T

use strict;
use warnings;
use Test::More;

my @TEST = (
    [CSV           => 'data-grid-sample.csv'],
    [Excel         => 'data-grid-sample.xls'],
    ['Excel::XLSX' => 'data-grid-sample.xlsx'],
);

plan tests => @TEST * 1 + 1;

use_ok('Data::Grid');

for my $pair (@TEST) {
    my ($class, $file) = @$pair;

    my $grid = Data::Grid->parse("t/$file");

    isa_ok($grid, "Data::Grid::$class", "$class instance");

    $grid = Data::Grid->parse(source => "t/$file", header => 1);
}
