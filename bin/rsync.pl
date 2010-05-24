#!/usr/bin/perl

use strict;
use warnings;

chdir 'web' || die $!;
system ('/usr/local/bin/ttree', '--EVAL_PERL', '-f', 'lib/site.cfg', '-a');
system('rsync', '--delete', '-qa',  'html/', '/home/justin/web/adelaidepm/');


