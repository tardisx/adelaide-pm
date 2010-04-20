use Test::More tests => 3;

use lib 'lib';

use_ok 'PM::Meeting::Dates::Adelaide::Social';

my $obj = PM::Meeting::Dates::Adelaide::Social->new();

ok (defined $obj, 'object exists');
ok ($obj->isa('PM::Meeting::Dates::Adelaide::Social'), 'right kind');
