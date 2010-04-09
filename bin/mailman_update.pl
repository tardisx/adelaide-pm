#!/usr/bin/perl

use strict;
use warnings;

use WWW::Mailman;

use Data::Dumper;


my $mm = WWW::Mailman->new(
  server   => 'mail.pm.org',
  list     => 'adelaide-pm',

  admin_password => 'deaweridmo'
);

my $admin = $mm->admin_nondigest();

warn Dumper($admin);


my $footer = { 'msg_footer' => qq{
_______________________________________________
http://adelaide.pm.org/
adelaide-pm\@pm.org
%(web_page_url)slistinfo%(cgiext)s/%(_internal_name)s
} };

$mm->admin_nondigest($footer);


