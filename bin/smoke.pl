#!/usr/bin/env perl

use File::Temp qw/tempfile/;

my ($fh, $filename) = tempfile(  TEMPLATE => 'tempXXXXX',
                                 SUFFIX => '.tar.gz');
warn $filename;
my $revision = `git show master^ | grep commit | perl -pne 's/\n//s;'`;
$revision =~ s/^commit\s+//;

my $platform = `uname`;
chomp $platform;

system ("/usr/bin/prove","--archive",$filename);
system ("/usr/local/bin/smolder_smoke_signal","--server","perlcode.info","--port","8008","--username","justin","--password",$ENV{SMOLDER_PASSWORD},"--file", $filename,  "--project","adelaidepm", "--revision", $revision, "--platform", $platform);

unlink $filename;

