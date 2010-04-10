package PM::Meeting::Dates;

use strict;
use warnings;

use PM::Meeting;

use DateTime;
use DateTime::Set;

use Carp qw/croak/;

use Moose;

has 'first' => ( is => 'rw', isa => 'DateTime' );
has 'final'  => ( is => 'rw', isa => 'DateTime' );

has 'dates' => ( is => 'rw', isa => 'DateTime::Set' );


sub last_meeting {
    my $self = shift;
    my $now  = DateTime->now();

    $self->setup_meeting_dates() unless $self->dates();

    my $iter = $self->dates()->iterator;
    my $last;

    my $id = 0;

    while ( my $dt = $iter->next ) {
        $id++;
        last if $dt >= $now;
        $last = $dt;
    }
    $id--;
    return if ( $id <= 0 );
    return PM::Meeting->new( date => $last, id => $id );
}

sub next_meeting {
    my $self = shift;
    my $now  = DateTime->now();

    my $id = 0;

    $self->setup_meeting_dates() unless $self->dates();

    my $iter = $self->dates()->iterator;
    while ( my $dt = $iter->next ) {
        $id++;
        next unless $dt >= $now;
        return PM::Meeting->new( date => $dt, id => $id );
    }
    return;
}

sub id_meeting {
    my $self = shift;
    my $wanted_id   = shift;
    my $now  = DateTime->now();

    my $id = 0;

    $self->setup_meeting_dates() unless $self->dates();

    my $iter = $self->dates()->iterator;
    while ( my $dt = $iter->next ) {
        $id++;
        next unless $id == $wanted_id;
        return PM::Meeting->new( date => $dt, id => $id );
    }
    return;
}


1;
