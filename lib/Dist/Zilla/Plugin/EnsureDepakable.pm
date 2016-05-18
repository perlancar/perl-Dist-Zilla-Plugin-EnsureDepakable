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

    my $res = Module::Depakable::prereq_depakable(
        prereqs => [grep { $_ ne 'perl' } keys %$rr_prereqs]);
    if ($res->[0] != 200) {
        $self->log_fatal(["Distribution not depakable: %s", $res->[1]]);
    }
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Make sure that distribution is depakable

=for Pod::Coverage .+

=head1 SYNOPSIS

In F<dist.ini>:

 [EnsureDepakable]


=head1 DESCRIPTION

This plugin will check that the distribution is "depakable", i.e. all the
modules in the distribution can be packed in a script using fatpack or datapack
technique. To do this, the plugin will feed all the distribution's
RuntimeRequires prerequisites to L<Module::Depakable>. The build will be aborted
if distribution is determined to be not depakable.


=head1 SEE ALSO

L<App::depak>

L<Module::Depakable>
