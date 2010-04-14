package PM::Meeting;

use strict;
use warnings;

use Moose;

# A unique id for this meeting
has 'id'   => ( is => 'rw', isa => 'Int' );

# The date of this meeting
has 'date' => ( is => 'rw', isa => 'DateTime' );

# Venue
has 'venue' => ( is => 'rw', isa => 'Str' );


sub nice_date {
    my $self = shift;

    my $dt = $self->date;
    return $dt->strftime("%a, %d %b");
}

1;

__END__

=head1 NAME
 
PM::Meeting - A Perl Mongers meeting

=head1 SYNOPSIS

  my $meeting = PM::Meeting->new( id => 1, date => $DateTimeObj, venue => 'local pub');

=head1 DESCRIPTION

This module provides objects representing individual Perl Mongers meetings.

=cut
