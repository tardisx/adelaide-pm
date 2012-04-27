use Test::More tests => 6;

use File::Temp qw/tempfile/;
 
($fh, $filename) = tempfile();

ok (chdir 'web', 'changed to web dir');

system ("ttree --EVAL_PERL -f lib/site.cfg -a --verbose > $filename");
ok ($? == 0, 'ttree ran a bit at least');

my @lines = <$fh>;

ok (@lines > 10, 'lines in output');

ok (scalar (grep /^\s+>/, @lines), 'saw > lines');
ok (scalar (grep /^\s+\+/, @lines), 'saw + lines');
ok (! scalar(grep /^\s+\!/, @lines), 'did not see ! lines');

close ($fh);

unlink $filename;
