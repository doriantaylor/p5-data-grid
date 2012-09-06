use strict;
use warnings;
use inc::Module::Install;

name     'Data-Grid';
abstract 'Data::Grid provides basic, incremental access to grid-shaped data.';
all_from 'lib/Data/Grid.pm';

requires 'Data::Table'             => '1.54';
requires 'File::MMagic'            => '1.27';
requires 'IO::Scalar'              => '2.110';
requires 'parent'                  => '0.223';
requires 'Spreadsheet::ParseExcel' => '0.57';
requires 'Spreadsheet::XLSX'       => '0.13';
requires 'Text::CSV'               => '1.18';

auto_install;
WriteAll;
