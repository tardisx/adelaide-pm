#!/usr/bin/perl

use strict;
use warnings;

use PM::Adelaide::Dates;

my $obj = PM::Adelaide::Dates->new();

warn $obj->next_meeting;
warn $obj->last_meeting;
