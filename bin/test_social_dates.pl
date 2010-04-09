#!/usr/bin/perl

use strict;
use warnings;

use DateTime::Set;
use DateTime::Span;
use Date::Holidays::AU qw/is_holiday/;

my $first = DateTime->new( year => 2010, month => 4, day => 1 );
my $last  = DateTime->new( year => 2012, month => 1, day => 1 );

my $dates = DateTime::Set->from_recurrence(
  span => DateTime::Span->from_datetimes( start => $first, end => $last ),
  recurrence => sub {
    return $_[0]->truncate( to => 'month' )->add( months => 1 )
      ->add( days => 25 );
  },
);

# example: remove the hour:minute:second information
$dates = $dates->map(
  sub {
    return $_->truncate( to => 'day' );
  }
);

# example: postpone or antecipate events which
#          match datetimes within another set
$dates = $dates->map(
  sub {
    while ( ( $_->day_of_week >=6 ) || 
            is_holiday( dt_ymd($_), 'SA') ) {
      $_->subtract( days => 2 ) if ($_->day_of_week >=6);
      $_->subtract( days => 1 ) if (is_holiday( dt_ymd($_), 'SA'));
    }
    return $_;
  }
);

my $iter = $dates->iterator;
my %dist;
while ( my $dt = $iter->next ) {
  print $dt->ymd . " " . $dt->day_name() . "\n";
  $dist{$dt->day_name}++;
}

foreach (keys %dist) {
  printf "%9s: %d\n", $_, $dist{$_};
}

sub dt_ymd {
  my $dt = shift;
  return ($dt->year, $dt->month, $dt->day);
}
