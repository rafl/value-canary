package Value::Canary;

use Carp 'cluck';
use Variable::Magic qw/wizard cast/;
use namespace::clean;

use Sub::Exporter -setup => {
    exports => ['canary'],
    groups  => { default => ['canary'] },
};

my $wiz = wizard data => sub { $_[1] },
                 free => sub { $_[1]->($_[0]) };

sub canary {
    my $cb = $_[1];
    $cb ||= sub { cluck "${ $_[0] } destroyed" };
    cast $_[0], $wiz, $cb;
}

1;
