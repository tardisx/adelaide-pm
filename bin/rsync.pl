#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
my $upload;
my $result = GetOptions ("upload" => \$upload);
die "bad args" unless $result;

chdir 'web' || die $!;
system ('/usr/local/bin/ttree', '--EVAL_PERL', '-f', 'lib/site.cfg', '-a');

system('rsync', '--delete', '-qa',  'html/', '/home/justin/web/adelaidepm/')
  if $upload;

