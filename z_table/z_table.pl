#!/usr/bin/perl -w
use strict;
use Tk;

use z_table::v_main_z_table;
use z_table::model_z_table;
use z_table::control_z_table;


my $v_main  = z_table::v_main_z_table->new();
my $model   = z_table::model_z_table->new();
my $control = z_table::control_z_table->new($v_main,$model);

$v_main ->set_controler($control);
$model->set_controler($control);

$control->sende('main_start');
Tk::MainLoop;