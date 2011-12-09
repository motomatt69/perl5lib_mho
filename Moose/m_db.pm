package Moose::m_db;
use strict;

use Moose;

has 'data' => (isa => 'Int', is => 'rw', required => 1, default => 25);







1;