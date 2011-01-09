package AnyEventX::Cancel;
# ABSTRACT: cancel all AnyEvent watchers
use strict;
use warnings;

our $VERSION;

use AnyEvent;

use Sub::Exporter -setup => {
    exports => ['cancel_all_watchers'],
};


my %loop_killers = (
    'AnyEvent::Impl::POE' => sub {
        POE::Kernel->stop;
    },
    'AnyEvent::Impl::Event' => sub {
        for my $watcher (Event::all_watchers()){
            $watcher->cancel;
        }
    },
    'AnyEvent::Impl::EV' => sub {
        EV::default_destroy();
        EV::default_loop();
    },
);

sub cancel_all_watchers(;@){
    my %args = @_;
    my $loop_type = AnyEvent::detect;
    my $loop_killer = $loop_killers{$loop_type};
    $loop_killer->() if $loop_killer;
    $AnyEvent::CondVar::Base::WAITING = 0;
    if (!$loop_killer && (my $w = $args{warning})) {
        if ($w eq '1') {
            print {*STDERR} "WARNING: UNSUPPORTED EVENT LOOP IN USE, ".
              "CHILD MUST NOT CALL INTO EVENT LOOP!\n";
        }
        else {
            print {*STDERR} $w;
        }
    }
}

1;
