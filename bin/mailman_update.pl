#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use WWW::Mailman;

use PM::Meeting::Dates::Adelaide::Social;
use PM::Meeting::Dates::Adelaide::Tech;

my $tech = PM::Meeting::Dates::Adelaide::Tech->new();
my $social = PM::Meeting::Dates::Adelaide::Social->new();

my $mm = WWW::Mailman->new(
  server   => 'mail.pm.org',
  list     => 'adelaide-pm',

  admin_password => 'deaweridmo'
);

my $admin = $mm->admin_nondigest();
my $next_social = $social->next_meeting()->nice_date();
my $next_tech   = $tech->next_meeting()->nice_date();

my $footer = { 'msg_footer' => qq{
___________________________________________________
http://adelaide.pm.org/   Next Social: $next_social
adelaide-pm\@pm.org        Next Tech:   $next_tech
%(web_page_url)slistinfo%(cgiext)s/%(_internal_name)s
} };

$mm->admin_nondigest($footer);
# die $footer->{msg_footer};

