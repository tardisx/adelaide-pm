package PM::Meeting::Dates::Adelaide::Tech;

use strict;
use warnings;
use Carp qw/croak/;

use Moose;

use DateTime;
use DateTime::Set;

use PM::Meeting;

extends 'PM::Meeting::Dates';

# Default venue.
our $default_venue = 'Quantum Adelaide';

our %date_venue_override = (
   '2010-12-16' => '115 Grenfell St, Adelaide',
);


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

Hardcoded list of tech meetings - they aren't regular.

=cut

sub setup_meeting_dates {

    my $self = shift;

    my @meeting_dates = ( 
                         DateTime->new( year => 2010, month =>  4, day => 28 ),
                         DateTime->new( year => 2010, month =>  8, day => 26 ),
                         DateTime->new( year => 2010, month => 12, day => 16 ),
                        );
    my $dates = DateTime::Set->from_datetimes( dates => [ @meeting_dates ] );

    $self->dates($dates);
}

1;
