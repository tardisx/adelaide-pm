#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

my $upload;   # shall we upload this?
my $verbose;  # shall we use verbose ttree?

my $result = GetOptions (upload   => \$upload,  
                         verbose  => \$verbose,);
die "bad args" unless $result;

my @verbose_args;
@verbose_args = ('--verbose') if ($verbose);

chdir 'web' || die $!;
system ('ttree', '--EVAL_PERL', '-f', 'lib/site.cfg', '-a', @verbose_args);

system('rsync', '--delete', '-qa',  'html/', '/home/justin/web/adelaidepm/')
  if $upload;

