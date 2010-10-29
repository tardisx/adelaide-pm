#!/usr/bin/perl

use strict;
use warnings;

use DateTime;
use Mail::Send;

use lib 'lib';

use PM::Meeting::Dates::Adelaide::Social;

my $advance = shift || 3;

my $obj = PM::Meeting::Dates::Adelaide::Social->new();

my $next = $obj->next_meeting();
my $check = DateTime->now()->add( days => $advance )->truncate( to => 'day' );

if ($check eq $next->date()->truncate( to => 'day' )) {
  my $msg = Mail::Send->new();
  $msg->subject('Next social advance warning: ' . $next->nice_date());
  $msg->to('justin@hawkins.id.au');
  my $fh = $msg->open ;
  print $fh "The next Adelaide.pm social is only $advance days away!\n";
  print $fh "\nSee you on " . $next->nice_date() . "!\n\n";
  print $fh "Regards, the Adelaide.pm automated reminder robot\n\n";
  close ($fh);
}
