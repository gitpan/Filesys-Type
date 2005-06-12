package Filesys::Type::Plugin::Windows;
use strict;

sub fstype {
    my $path = shift;

    return undef unless $^O =~ /win/i;

    require Win32;
    require Cwd;
    require File::Spec;

    my $cur = Cwd::cwd;
    my ($vol,$dir,$file) = File::Spec->splitpath($path);
    chdir File::Spec->catpath($vol,$dir);
    my $fstype = Win32::FsType();
    chdir $cur;
    $fstype;
}

1;
