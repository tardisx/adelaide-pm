use Test::More tests => 5;

use lib 'lib';

use_ok 'PM::Meeting::Dates::Adelaide::Tech';

my $obj = PM::Meeting::Dates::Adelaide::Tech->new();

ok (defined $obj, 'object exists');
ok ($obj->isa('PM::Meeting::Dates::Adelaide::Tech'), 'right kind');

ok (defined $obj->next_meeting(), 'can call next_meeting');
ok ($obj->next_meeting()->isa('PM::Meeting'), 'isa PM::Meeting');
