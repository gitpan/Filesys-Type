package Filesys::Type::Plugin::Unix;
use strict;

sub fstype {
    my $path = shift;

#Check we really are on a Unix type operating system
    return undef unless -d '/etc';
    
    my $df = `df $path`;
    my $mounted = `mount`;   # Does not need root

    my ($mounted_fs) = $df =~ /\d\%\s(\S+)/ or return undef;
    my ($fstype) = $mounted =~ /on\s$mounted_fs\stype\s(\w+)/;
    $fstype;
}

1;

