#!/usr/bin/perl

use strict;
use warnings;
use Mail::Box::MH;
use Mail::Box::Mbox;
use Getopt::Long;

=head1 NAME

ml2web.pl - turn MH mail files into TT files

=cut

my %month2name = (
  '01'  => 'January',
  '02'  => 'February',
  '03'  => 'March',
  '04'  => 'April',
  '05'  => 'May',
  '06'  => 'June',
  '07'  => 'July',
  '08'  => 'August',
  '09'  => 'September',
  '10'  => 'October',
  '11'  => 'November',
  '12'  => 'December',
);

my $result;
my ($autoformat, $only_year, $only_month, $obfuscate);

$result = GetOptions ("autoformat" => \$autoformat,
                      "year=s"     => \$only_year,
                      "month=s"    => \$only_month,
                      "obfuscate"  => \$obfuscate,
);

die "bad options\n" if (! $result);

if ($autoformat) {
  require Text::Autoformat;
  Text::Autoformat->import('autoformat');
}

$ENV{TZ} = 'Australia/Adelaide';

my $mbox_dir = '/var/lib/ecartis/archives/adelaidepm/mbox';
my $tt_dir = 'pages/mailing';

my $mails = {};

my $folder = new Mail::Box::Mbox folder =>  $mbox_dir, lock_type=> 'NONE';

my @subs = $folder->listSubFolders;

my $fh = {};

my $main_index = {};

foreach (sort @subs) {
  my $newFolder = $folder->openSubFolder($_);
  my $count = 0;
  foreach my $messageId ( $newFolder->messageIds ) {
    $count++;
    my $message = $newFolder->find($messageId);
    my ($year, $month) = ts_to_year_month($message->timestamp());

    next if ($only_month && $only_year && ($only_month != $month ||
                                           $only_year  != $year));

    $main_index->{$year}->{$month}++;
                                          
    my $subject = $message->subject;
    my $from    = $message->from;
    my $body    = $message->body;

    # reformat the body
    if ($autoformat) {
      $body = autoformat({ all => 1 }, $body);
    }

    # obfuscate
    if ($obfuscate) {
      $subject =~ s/\w/X/g;
      $from    =~ s/\w/X/g;
      $body    =~ s/\w/X/gms;
    }

    # add to list
    my $fhname = "$year-$month";

    # open a filehandle for this months index if necessary
    if (! $fh->{$fhname} ) {
      mkdir "$tt_dir/$year" unless -d "$tt_dir/$year";
      mkdir "$tt_dir/$year/$month" unless -d "$tt_dir/$year/$month";
      open $fh->{$fhname}, ">", "$tt_dir/$year/$month/index.tt2";
    }

    # update monthly index
    print {$fh->{$fhname}} "$count <a href=\"/mailing/$year/$month/$count.html\">";
    print {$fh->{$fhname}} "$subject";
    print {$fh->{$fhname}} "</a><br />\n";

    open my $mailfh, ">", "$tt_dir/$year/$month/$count.tt2";
    print $mailfh "Subject: $subject<br>";
    print $mailfh "Date:    ".localtime($message->timestamp())."<br>";
    print $mailfh "From:    $from<br><br>";
    print $mailfh "<pre>\n";
    print $mailfh $body;
    print $mailfh "</pre>\n";
    close $mailfh;
  }
}

# update the main archive index page.
open my $main_index_fh, ">", "$tt_dir/index.tt2";
print $main_index_fh "<h2>Mailing list archive</h2>";
print $main_index_fh "<ul>";
foreach my $this_year (sort keys %$main_index) {
  print $main_index_fh "<li>$this_year</li>";
  print $main_index_fh "<ul>";
  foreach my $this_month (sort keys %{$main_index->{$this_year}}) {
    print $main_index_fh "<li><a href=\"/mailing/$this_year/$this_month/\">$month2name{$this_month}</a></li>";
  }
  print $main_index_fh "</ul>";
}
print $main_index_fh "</ul>";
close $main_index_fh;


exit;

sub ts_to_year_month {
  my $ts = shift;
  my @ts = localtime($ts);
  return sprintf("%04d", $ts[5]+1900), sprintf("%02d", $ts[4]+1);
}

