use strict;
use warnings;
use inc::Module::Install;

name     'Data-Grid';
abstract 'Data::Grid provides basic, incremental access to grid-shaped data.';
all_from 'lib/Data/Grid.pm';

requires 'Text::CSV';
requires 'Spreadsheet::ParseExcel';
requires 'Spreadsheet::XLSX';
requires 'Data::Table';
requires 'File::MMagic';
requires 'Scalar::Util';

auto_install;
WriteAll;
