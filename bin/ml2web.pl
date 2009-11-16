#!/usr/bin/perl

use strict;
use warnings;
use Mail::Box::MH;
use Mail::Box::Mbox;

=head1 NAME

ml2web.pl - turn MH mail files into TT files

=cut

my $mh_dir = '/var/lib/ecartis/archives/adelaidepm/mh';
# my $mbox_dir = '/var/lib/ecartis/archives/adelaidepm/mbox';
my $mbox_dir = '/var/lib/ecartis/archives/people/mbox';
my $tt_dir = 'pages/mailing';

my $mails = {};

my $folder = new Mail::Box::Mbox folder =>  $mbox_dir, lock_type=> 'NONE';

my @subs = $folder->listSubFolders;

my $fh = {};

foreach (sort @subs) {
  warn "PRocessing $_";
  my $newFolder = $folder->openSubFolder($_);
  my $count = 0;
  foreach my $messageId ( $newFolder->messageIds ) {
    $count++;
    my $message = $newFolder->find($messageId);
    my ($year, $month) = ts_to_year_month($message->timestamp());
    # add to list
    my $fhname = "$year-$month";
    if (! $fh->{$fhname} ) {
      mkdir "$tt_dir/$year" unless -d "$tt_dir/$year";
      mkdir "$tt_dir/$year/$month" unless -d "$tt_dir/$year/$month";
      open $fh->{$fhname}, ">", "$tt_dir/$year/$month.tt2";
    }
    print {$fh->{$fhname}} $count . "\n";
    open my $mailfh, ">", "$tt_dir/$year/$month/$count.tt2";
    print $mailfh "<pre>\n";
    print $mailfh $message->body;
    print $mailfh "</pre>\n";
    close $mailfh;
  }
}


exit;

sub ts_to_year_month {
  my $ts = shift;
  my @ts = localtime($ts);
  return sprintf("%04d", $ts[5]+1900), sprintf("%02d", $ts[4]+1);
}

