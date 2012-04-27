#!/usr/bin/env perl

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

  # Note that this used to be hardcoded. If you think
  # you can find it by searching git commits, please note
  # that it has already been changed :-)
  admin_password => $ENV{MAILMAN_PASSWORD},
);

my $admin = $mm->admin_nondigest();
my $next_social_date = $social->next_meeting() ? $social->next_meeting()->nice_date()
                                               : 'TBA';
my $next_tech_date   = $tech->next_meeting() ? $tech->next_meeting()->nice_date() 
                                               : 'TBA';

my $footer = { 'msg_footer' => qq{
___________________________________________________
http://adelaide.pm.org/   Next Social: $next_social_date
adelaide-pm\@pm.org        Next Tech:   $next_tech_date
%(web_page_url)slistinfo%(cgiext)s/%(_internal_name)s
} };

$mm->admin_nondigest($footer);
# die $footer->{msg_footer};

