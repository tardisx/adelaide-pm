#!/usr/bin/perl

use strict;
use warnings;

use PM::Meeting::Dates::Adelaide::Social;

my $obj = PM::Meeting::Dates::Adelaide::Social->new();

warn "NEXT: " . $obj->next_meeting->id . " " .  $obj->next_meeting->date;
warn "PREV: " . $obj->last_meeting->id . " " .  $obj->last_meeting->date;

my $count;
while (my $meet = $obj->next) {
   warn $meet->id . " " . $meet->date . " " . $meet->venue;
   last if ($count++ > 20);
}
  
