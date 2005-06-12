
package Filesys::Type;
use strict;

BEGIN {
	use Exporter ();
	use vars qw ($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
	$VERSION     = 0.01;
	@ISA         = qw (Exporter);
	#Give a hoot don't pollute, do not export more than needed by default
	@EXPORT      = qw ();
	@EXPORT_OK   = qw (fstype case);
	%EXPORT_TAGS = (all => [qw(fstype case)]);
}


########################################### main pod documentation begin ##
# Below is the stub of documentation for your module. You better edit it!


=head1 NAME

Filesys::Type - Portable way of determining the type of a file system.

=head1 SYNOPSIS

  use Filesys::Type qw(fstype);
  
  ...
  my $fs = '/mnt/hda7';
  warn "Not able to share with Windows"
     if (fstype($fs) ne 'vfat');


=head1 DESCRIPTION

This module provides a portable interface, either to Unix mount -n
or to Win32::filesys or to another native OS interface.

The module is pluggable, which will allow for other operating systems
to be added in future without needing to change the core module.

=head2 fstype

This exportable function takes a string, which is a file or directory 
path, and returns the file system type, e.g. vfat, ntfs, ext2, etc.
Note that the exact string returned is operating system dependent.

=head2 case

This is another exportable function that takes a path as input, and
returns one of the following:

=over 4

=item C<sensitive>

like Unix ext2, ext3, etc.

=item C<lower>

VMS ODS-2 filenames are case insensitive. System services return the
names in upper case, but the CRTL which provides globbing and the
command line interface turns to lower case.

=item C<insensitive>

This is the behaviour of Windows file systems, FAT16, FAT32 and NTFS.
The file names are case insensitive, i.e. foo, Foo and FOO refer to the
same file, but the initial case of the letters of the file name is
preserved from the time it was created.

=head1 BUGS

Please report bugs to http://rt.cpan.org. Post to bug-filesys-type@rt.cpan.org


=head1 HISTORY

0.01 Sun Jun 12 2005
	- original version; created by ExtUtils::ModuleMaker 0.32


=head1 AUTHOR

	I. Williams
	ivorw@cpan.org

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

L<Win32>.

=cut

use Module::Pluggable require => 1;

sub fstype {
    my $path = shift;

    my @plugins = __PACKAGE__->plugins;

    for (@plugins) {
	my $plugfunc = "${_}::fstype";
	no strict 'refs';
	my $rv = &$plugfunc($path);
	return $rv if $rv;
    }
    undef;
}

our %case_sensitivity = (
	msdos => 'insensitive',
	umsdos => 'insensitive',
	vfat => 'insensitive',
	ntfs => 'insensitive',
	minix => 'sensitive',
	xiafs => 'sensitive',
	ext2 => 'sensitive',
	ext3 => 'sensitive',
	iso9660 => 'sensitive',
	hpfs => 'sensitive',
	sysv => 'sensitive',
	nfs => 'sensitive',
	smb => 'insensitive',
	ncpfs => 'insensitive',
	FAT => 'insensitive',
	FAT32 => 'insensitive',
	CDFS => 'insensitive',
	NTFS => 'insensitive',
	'ODS-2' => 'lower',
	);

sub case {
    my $path = shift;

    my $fstype = fstype($path);

    $case_sensitivity{$fstype};
}

1; #this line is important and will help the module return a true value
__END__

