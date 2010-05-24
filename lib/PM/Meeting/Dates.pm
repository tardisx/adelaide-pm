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

has 'iterator' => ( is => 'rw', isa => 'DateTime::Set', clearer => 'clear_iterator' );

=head2 last_meeting

Return the meeting that happened most recently.

=cut

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
    return $self->setup_meeting( date => $last, id => $id );
}

=head2 next_meeting

Return the meeting object for the next upcoming meeting.

=cut

sub next_meeting {
    my $self = shift;
    my $now  = DateTime->now();

    my $id = 0;

    $self->setup_meeting_dates() unless $self->dates();

    my $iter = $self->dates()->iterator;
    while ( my $dt = $iter->next ) {
        $id++;
        next unless $dt >= $now;
        return $self->setup_meeting( date => $dt, id => $id );
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


=head2 next

Return the next one.

=cut

sub next {
    my $self = shift;
    our $id;

    if (! $self->iterator) {
      $id = 0;
      $self->iterator($self->dates()->iterator)
    }

    my $next = $self->iterator->next;
    $id++;
    if (! $next) {
        $self->clear_iterator();
        return undef;
    }

    return $self->setup_meeting( date => $next, id => $id );
}

sub setup_meeting {
  my $self = shift;

  confess "setup_meeting was not provided by $self";
}

sub setup_meeting_dates {
  my $self = shift;

  confess "setup_meeting_dates was not provided by $self";
}


1;
