use Test::More tests => 8;

use lib 'lib';

use_ok 'PM::Meeting::Dates::Adelaide::Social';

my $obj = PM::Meeting::Dates::Adelaide::Social->new();

ok (defined $obj, 'object exists');
ok ($obj->isa('PM::Meeting::Dates::Adelaide::Social'), 'right kind');

ok (defined $obj->next_meeting(), 'can call next_meeting');
ok ($obj->next_meeting()->isa('PM::Meeting'), 'isa PM::Meeting');

my $meeting_8 = $obj->id_meeting(8);
ok ($meeting_8->isa('PM::Meeting'), 'isa PM::Meeting');
ok ($meeting_8->id() == 8, 'meeting id correct');
ok ($meeting_8->date() =~ /2010-10-28/, 'date correct');
