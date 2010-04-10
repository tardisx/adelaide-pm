package PM::Meeting::Dates::Adelaide;

use strict;
use warnings;

use Moose;
use DateTime;
use DateTime::Set;
use DateTime::Span;
use Date::Holidays::AU qw/is_holiday/;

extends 'PM::Meeting::Dates';

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

    $self->dates($dates);

}


sub _dt_ymd {
    my $dt = shift;
    return ( $dt->year, $dt->month, $dt->day );
}

1;
