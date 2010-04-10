package PM::Meeting;

use strict;
use warnings;

use Moose;

# A unique id for this meeting
has 'id'   => ( is => 'rw', isa => 'Int' );

# The date of this meeting
has 'date' => ( is => 'rw', isa => 'DateTime' );

1;
