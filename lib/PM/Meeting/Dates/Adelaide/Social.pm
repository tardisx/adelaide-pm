package PM::Meeting::Dates::Adelaide::Social;

use strict;
use warnings;
use Carp qw/croak/;

use Moose;

use DateTime;
use DateTime::Set;
use DateTime::Span;

use Date::Holidays::AU qw/is_holiday/;

use PM::Meeting;

extends 'PM::Meeting::Dates';

# Override dates, either moving them to a new date, or skipping them entirely.
# Note that it would be extremely bad to move or delete a date that had already
# occurred.
our %date_override = (
  # EXAMPLE move this meeting to the 26th
  # '2010-04-23' => '2010-09-26',
  # EXAMPLE skip this meeting XXX this is broken see below
  # '2010-07-26' => undef,
  '2010-10-26' => '2010-10-28',
  '2010-11-26' => '2010-11-29',
  '2010-12-24' => '2010-12-16',
);

# Override venues.
our %date_venue_override = (
   '2010-04-23' => 'Brecknock',
   '2010-12-16' => 'Unknown!',
);

# Default venue.
our $default_venue = 'Exeter';


=head2 setup_meeting

Setup this meeting, by id and date.

=cut

sub setup_meeting {
  my $self = shift;
  my %args = @_;
  my $dt = $args{date};
  my $id = $args{id};

  croak "No id" unless $id;
  croak "No date" unless $dt;

  my $meeting = PM::Meeting->new( date => $dt, id => $id );
  my $venue   = $date_venue_override{$dt->format_cldr('yyyy-MM-dd')} || $default_venue;
  $meeting->venue($venue);

  return $meeting;
}

=head2 setup_meeting_dates

Construct a DateTime::Set consisting of all the social dates for Adelaide.pm meetings
for the foreseeable future.

=cut

sub setup_meeting_dates {

    my $self = shift;

    # First and final meetings
    $self->first( DateTime->new( year => 2010, month => 2, day => 1 ) );
    $self->final( DateTime->new( year => 3012, month => 1, day => 1 ) );

    my $dates = DateTime::Set->from_recurrence(
        span => DateTime::Span->from_datetimes(
            start => $self->first(),
            end   => $self->final(),
        ),
        recurrence => sub {
            return $_[0]->truncate( to => 'month' )->add( months => 1 )
                ->add( days => 25 );
        },
    );

    # Truncate to the day
    $dates = $dates->map(
        sub {
            return $_->truncate( to => 'day' );
        }
    );

    # Do not let it be an SA public holiday or weekend
    $dates = $dates->map(
        sub {
            while ( ( $_->day_of_week >= 6 )
                || is_holiday( _dt_ymd($_), 'SA' ) )
            {
                $_->subtract( days => 2 ) if ( $_->day_of_week >= 6 );
                $_->subtract( days => 1 )
                    if ( is_holiday( _dt_ymd($_), 'SA' ) );
            }
            return $_;
        }
    );

    # Lastly (and must be last), check our overrides
    $dates = $dates->map(
      sub {
        my $date_str = sprintf("%04d-%02d-%02d", $_->year, $_->month, $_->day);
        if ($date_override{$date_str}) {
          my @ymd = split(/\-/, $date_override{$date_str});
          $_->set( year => $ymd[0], month => $ymd[1], day => $ymd[2] );
        }
        return $_;
      }
    );

    # Remove meetings that we skip
    # XXX currently broken
    $dates = $dates->grep(
      sub {
        my $date_str = sprintf("%04d-%02d-%02d", $_->year, $_->month, $_->day);
        if (exists $date_override{$date_str} && ! defined $date_override{$date_str}) {
          return (0);
        }
        return (1);
      }
    );

    $self->dates($dates);
}


sub _dt_ymd {
    my $dt = shift;
    return ( $dt->year, $dt->month, $dt->day );
}

1;
