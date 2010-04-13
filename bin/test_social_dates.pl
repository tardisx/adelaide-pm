#!/usr/bin/perl

use strict;
use warnings;

use PM::Meeting::Dates::Adelaide;

my $obj = PM::Meeting::Dates::Adelaide->new();

warn "NEXT: " . $obj->next_meeting->id . " " .  $obj->next_meeting->date;
warn "PREV: " . $obj->last_meeting->id . " " .  $obj->last_meeting->date;

warn "next venue: " . $obj->next_meeting->venue;
