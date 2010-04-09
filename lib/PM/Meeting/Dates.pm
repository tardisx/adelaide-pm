package PM::Meeting::Dates;

use strict;
use warnings;

use DateTime;
use DateTime::Set;
use DateTime::Span;
use Date::Holidays::AU qw/is_holiday/;

use Carp qw/croak/;

use Moose;

has 'first' => ( is => 'rw', isa => 'DateTime' );
has 'last'  => ( is => 'rw', isa => 'DateTime' );
has 'dates' => ( is => 'rw', isa => 'DateTime::Set' );

=pod

our $first = DateTime->new( year => 2010, month => 2, day => 1 );
our $last  = DateTime->new( year => 2012, month => 1, day => 1 );


=cut

sub _setup {
    my $self = shift;

    $self->first(DateTime->new( year => 2010, month => 2, day => 1 ));
    $self->last(DateTime->new( year => 2012, month => 1, day => 1 ));
    
    croak "no first" unless $self->first();
    croak "no last"  unless $self->last();

    my $dates = DateTime::Set->from_recurrence(
        span => DateTime::Span->from_datetimes(
            start => $self->first(),
            end   => $self->last(),
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

    # Do not let it be a public holiday or weekend
    $dates = $dates->map(
        sub {
            while ( ( $_->day_of_week >= 6 )
                || is_holiday( dt_ymd($_), 'SA' ) )
            {
                $_->subtract( days => 2 ) if ( $_->day_of_week >= 6 );
                $_->subtract( days => 1 )
                    if ( is_holiday( dt_ymd($_), 'SA' ) );
            }
            return $_;
        }
    );

    $self->dates($dates);
    
}


sub last_meeting {
    my $self = shift;
    my $now  = DateTime->now();

    $self->_setup() unless $self->dates();
    
    my $iter = $self->dates()->iterator;
    my $last;

    while ( my $dt = $iter->next ) {
        last if $dt >= $now;
        $last = $dt;
    }
    return $last;
}

sub next_meeting {
    my $self = shift;
    my $now  = DateTime->now();

    $self->_setup() unless $self->dates();
    
    my $iter = $self->dates()->iterator;
    while ( my $dt = $iter->next ) {
        next unless $dt >= $now;
        return $dt;
    }
    return;
}

sub meeting_id {
    my $self    = shift;
    my $meeting = shift;

    $self->_setup() unless $self->dates();
    
    my $iter = $self->dates()->iterator;
    my $id   = 0;
    while ( my $dt = $iter->next ) {

        $id++;
        return $id if $dt eq $meeting;
    }
    return;
}

sub id_meeting {
    my $self = shift;
    my $id = shift;

    $self->_setup() unless $self->dates();
    
    my $iter = $self->dates()->iterator;
    while ( my $dt = $iter->next ) {
        $id--;
        return $dt if !$id;
    }
    return;
}


sub dt_ymd {
    my $dt = shift;
    return ( $dt->year, $dt->month, $dt->day );
}


1;
