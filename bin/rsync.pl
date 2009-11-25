#!/usr/bin/perl

use strict;
use warnings;

system('rsync', '-a', '/home/justin/Maildir/.lists.adelaidepm/', '/home/justin/working/adelaidepm/archive/');
