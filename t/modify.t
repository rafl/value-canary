use strict;
use warnings;
use Test::More;

use Value::Canary;

{
    my $i = 0;

    my $foo = { bar => 42, baz => 23 };
    canary $foo, sub { $i++ };

    $foo->{bar} = 23;
    is $i, 0;

    $foo = { bar => 23, baz => 23 };
    is $i, 1;
}

done_testing;
