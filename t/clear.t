use strict;
use warnings;
use Test::More;

use Value::Canary;

{
    my $i = 0;

    my @foo = (42);
    canary @foo, sub { $i++ };

    is $i, 0;
    undef @foo;
    is $i, 1;
    @foo = (23);
    undef @foo;
    is $i, 1;
}

{
    my $i = 0;
    my $foo = 42;
    canary $foo, sub { $i++ };

    is $i, 0;
    $foo = 23;
    is $i, 1;
    undef $foo;
    is $i, 1;
}

done_testing;
