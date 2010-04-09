package PM::Adelaide::Dates;

use strict;
use warnings;

use DateTime;
use DateTime::Set;
use DateTime::Span;
use Date::Holidays::AU qw/is_holiday/;

our $first = DateTime->new( year => 2010, month => 2, day => 1 );
our $last  = DateTime->new( year => 2012, month => 1, day => 1 );

our $dates = DateTime::Set->from_recurrence(
  span => DateTime::Span->from_datetimes( start => $first, end => $last ),
  recurrence => sub {
    return $_[0]->truncate( to => 'month' )->add( months => 1 )
      ->add( days => 25 );
  },
);

$dates = $dates->map(
  sub {
    return $_->truncate( to => 'day' );
  }
);

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


sub dt_ymd {
  my $dt = shift;
  return ($dt->year, $dt->month, $dt->day);
}

sub last_meeting {
  my $now = DateTime->now();

  my $iter = $dates->iterator;
  my $last;

  while ( my $dt = $iter->next ) {
    warn "MEET: $dt NOW: $now";
    last if $dt >= $now;
    $last = $dt;
  }
  return $last;
}

sub next_meeting {
  my $now = DateTime->now();

  my $iter = $dates->iterator;
  while ( my $dt = $iter->next ) {
    next unless $dt >= $now;
    return $dt;
  }
  return;
}

sub meeting_id {
  my $class = shift;
  my $meeting = shift;

  my $iter = $dates->iterator;
  my $id = 0;
  while ( my $dt = $iter->next ) {
    warn "COMP $dt and $meeting";
    $id++;
    return $id if $dt eq $meeting;
  }
  return;
}

sub id_meeting {
  my $class = shift;
  my $id = shift;

  my $iter = $dates->iterator;
  while ( my $dt = $iter->next ) {
    $id--;
    return $dt if ! $id;
  }
  return;
}


1;
