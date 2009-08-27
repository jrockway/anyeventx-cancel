use strict;
use warnings;

print "1..2\n";

use AnyEvent;
use AnyEventX::Cancel qw(cancel_all_watchers);

print "# ", AnyEvent::detect, "\n";

my $foo = sub { };
my $t = AnyEvent->timer( after => 0, interval => .1, cb => sub { $foo->() } );

my $t2;
pipe my $r, my $w or die;
if(fork){
    close $w;
    $t2 = AnyEvent->timer( after => 2, cb => sub {
        my $child = <$r>;
        print $child;
        print "ok 2 - parent\n";
        exit 0;
    });
}
else {
    close $r;
    cancel_all_watchers( warning => 1 );
    $foo = sub { print "not ok\n# FAIL FAIL FAIL\n" };
    $t2 = AnyEvent->timer( after => 1, cb => sub {
        print {$w} "ok 1 - child\n";
        close $w;
        exit 0;
    });
}

AnyEvent->condvar->recv;
