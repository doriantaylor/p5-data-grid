use strict;
use warnings;
use inc::Module::Install;

name     'Data-Grid';
abstract  'Data::Grid provides basic, incremental access to grid-shaped data.';
readme_from 'lib/Data/Grid.pm';
all_from 'lib/Data/Grid.pm';

resources repository => 'https://github.com/doriantaylor/p5-data-grid';

# metaobject stuff
requires 'Moo'        => '2.0';
requires 'Type::Tiny' => '1.0';

# actual do-the-job stuff

requires 'IO::Scalar'              => '2.110';
requires 'parent'                  => '0.223';
requires 'Spreadsheet::ParseExcel' => '0.57';
requires 'Spreadsheet::XLSX'       => '0.13';
requires 'Text::CSV'               => '1.18';

# don't strictly need these but they are useful

recommends 'File::MMagic'   => '1.27';
recommends 'File::MimeInfo' => '0.27';
recommends 'Data::Table'    => '1.54';

auto_install;
WriteAll;
