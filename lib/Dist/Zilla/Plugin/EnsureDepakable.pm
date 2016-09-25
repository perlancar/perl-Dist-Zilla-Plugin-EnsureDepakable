package Dist::Zilla::Plugin::EnsureDepakable;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Moose;
with 'Dist::Zilla::Role::InstallTool';

use Module::Depakable;
use namespace::autoclean;

sub setup_installer {
    my ($self) = @_;

    my $prereqs_hash = $self->zilla->prereqs->as_string_hash;
    my $rr_prereqs = $prereqs_hash->{runtime}{requires} // {};

    return unless keys %$rr_prereqs;

    my $prereqs = [grep { $_ ne 'perl' } keys %$rr_prereqs];
    $self->log_debug(["Checking whether prereqs are depakable: %s", $prereqs]);
    my $res = Module::Depakable::prereq_depakable(prereqs => $prereqs);
    if ($res->[0] != 200) {
        $self->log_fatal(["Distribution not depakable: %s", $res->[1]]);
    }
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Make sure that distribution is "depakable"

=for Pod::Coverage .+

=head1 SYNOPSIS

In F<dist.ini>:

 [EnsureDepakable]


=head1 DESCRIPTION

This plugin helps make sure that you do not add a (direct, or indirect)
dependency to a non-core XS module, so that all your distribution's modules can
be use-d by a script that wants to be packed so it can be run with only
requiring core perl modules.

See L<Module::Depakable> for more details on the meaning of "depakable".


=head1 SEE ALSO

L<App::depak>

L<Module::Depakable>, L<depakable>

L<Dist::Zilla::Plugin::Depak>
