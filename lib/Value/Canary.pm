package Value::Canary;
# ABSTRACT: Callbacks for value destruction

use Carp 'cluck';
use Scalar::Util qw/refaddr weaken/;
use Variable::Magic qw/wizard cast dispell/;
use namespace::clean;

use Sub::Exporter -setup => {
    exports => ['canary'],
    groups  => { default => ['canary'] },
};

=head1 SYNOPSIS

    use Value::Canary;

    my $i = 0;

    {
        my $value = 42;
        canary $value, sub { $i++ };

        ...

        # $i is still 0
    } # end of scope causes $value to be destroyed and the callback to be invoked

    # $i is now 1

=head1 DESCRIPTION

This module provides an easy way to get notified as soon as a value is being
destroyed. This is mostly handy for debugging purposes, when you want to find
out which code is throwing the value you passed in away, instead of using it
for something useful.

=cut

my $wiz;
$wiz = wizard data => sub { $_[1] },
    set => sub {
        &dispell($_[0], $wiz) or die; # FUCK YOU, prototypes!
        $_[1]->{cb}->(\'???')
            if refaddr $_[0] != refaddr $_[1]->{val};
        ();
    },
    (map {
        $_ => sub {
            $_[1]->{cb}($_[0]);
            dispell $_[0], $wiz or die;
            ();
        }
    } qw/free clear/);

=head1 FUNCTIONS

=head2 canary ($variable, $callback?)

Registers a C<$callback> to be called as soon as C<$variable> is being
destroyed. The callback will be invoked with a reverence to the C<$variable> as
its only argument. If no callback is given, a default callback will be used.
The default callback will warn with a full stack trace of where the value is
being destroyed, as well as the message C<"$value destroyed">.

This function is exported by default. See L<Sub::Exporter> on how to customize
how exactly exporting happens.

=cut

sub canary {
    my $cb = $_[1];
    $cb ||= sub { cluck "${ $_[0] } destroyed" };
    cast $_[0], $wiz, { cb => $cb, val => weaken \$_[0] };
}

=head1 SEE ALSO

L<Variable::Magic>

L<Scope::Guard>

L<Object::Deadly>

=cut

1;
