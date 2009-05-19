# libguestfs generated file
# WARNING: THIS FILE IS GENERATED BY 'src/generator.ml'.
# ANY CHANGES YOU MAKE TO THIS FILE WILL BE LOST.
#
# Copyright (C) 2009 Red Hat Inc.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

=pod

=head1 NAME

Sys::Guestfs - Perl bindings for libguestfs

=head1 SYNOPSIS

 use Sys::Guestfs;
 
 my $h = Sys::Guestfs->new ();
 $h->add_drive ('guest.img');
 $h->launch ();
 $h->wait_ready ();
 $h->mount ('/dev/sda1', '/');
 $h->touch ('/hello');
 $h->sync ();

=head1 DESCRIPTION

The C<Sys::Guestfs> module provides a Perl XS binding to the
libguestfs API for examining and modifying virtual machine
disk images.

Amongst the things this is good for: making batch configuration
changes to guests, getting disk used/free statistics (see also:
virt-df), migrating between virtualization systems (see also:
virt-p2v), performing partial backups, performing partial guest
clones, cloning guests and changing registry/UUID/hostname info, and
much else besides.

Libguestfs uses Linux kernel and qemu code, and can access any type of
guest filesystem that Linux and qemu can, including but not limited
to: ext2/3/4, btrfs, FAT and NTFS, LVM, many different disk partition
schemes, qcow, qcow2, vmdk.

Libguestfs provides ways to enumerate guest storage (eg. partitions,
LVs, what filesystem is in each LV, etc.).  It can also run commands
in the context of the guest.  Also you can access filesystems over FTP.

=head1 ERRORS

All errors turn into calls to C<croak> (see L<Carp(3)>).

=head1 METHODS

=over 4

=cut

package Sys::Guestfs;

use strict;
use warnings;

require XSLoader;
XSLoader::load ('Sys::Guestfs');

=item $h = Sys::Guestfs->new ();

Create a new guestfs handle.

=cut

sub new {
  my $proto = shift;
  my $class = ref ($proto) || $proto;

  my $self = Sys::Guestfs::_create ();
  bless $self, $class;
  return $self;
}

=item $h->add_cdrom ($filename);

This function adds a virtual CD-ROM disk image to the guest.

This is equivalent to the qemu parameter C<-cdrom filename>.

=item $h->add_drive ($filename);

This function adds a virtual machine disk image C<filename> to the
guest.  The first time you call this function, the disk appears as IDE
disk 0 (C</dev/sda>) in the guest, the second time as C</dev/sdb>, and
so on.

You don't necessarily need to be root when using libguestfs.  However
you obviously do need sufficient permissions to access the filename
for whatever operations you want to perform (ie. read access if you
just want to read the image or write access if you want to modify the
image).

This is equivalent to the qemu parameter C<-drive file=filename>.

=item $h->aug_close ();

Close the current Augeas handle and free up any resources
used by it.  After calling this, you have to call
C<$h-E<gt>aug_init> again before you can use any other
Augeas functions.

=item ($nrnodes, $created) = $h->aug_defnode ($name, $expr, $val);

Defines a variable C<name> whose value is the result of
evaluating C<expr>.

If C<expr> evaluates to an empty nodeset, a node is created,
equivalent to calling C<$h-E<gt>aug_set> C<expr>, C<value>.
C<name> will be the nodeset containing that single node.

On success this returns a pair containing the
number of nodes in the nodeset, and a boolean flag
if a node was created.

=item $nrnodes = $h->aug_defvar ($name, $expr);

Defines an Augeas variable C<name> whose value is the result
of evaluating C<expr>.  If C<expr> is NULL, then C<name> is
undefined.

On success this returns the number of nodes in C<expr>, or
C<0> if C<expr> evaluates to something which is not a nodeset.

=item $val = $h->aug_get ($path);

Look up the value associated with C<path>.  If C<path>
matches exactly one node, the C<value> is returned.

=item $h->aug_init ($root, $flags);

Create a new Augeas handle for editing configuration files.
If there was any previous Augeas handle associated with this
guestfs session, then it is closed.

You must call this before using any other C<$h-E<gt>aug_*>
commands.

C<root> is the filesystem root.  C<root> must not be NULL,
use C</> instead.

The flags are the same as the flags defined in
E<lt>augeas.hE<gt>, the logical I<or> of the following
integers:

=over 4

=item C<AUG_SAVE_BACKUP> = 1

Keep the original file with a C<.augsave> extension.

=item C<AUG_SAVE_NEWFILE> = 2

Save changes into a file with extension C<.augnew>, and
do not overwrite original.  Overrides C<AUG_SAVE_BACKUP>.

=item C<AUG_TYPE_CHECK> = 4

Typecheck lenses (can be expensive).

=item C<AUG_NO_STDINC> = 8

Do not use standard load path for modules.

=item C<AUG_SAVE_NOOP> = 16

Make save a no-op, just record what would have been changed.

=item C<AUG_NO_LOAD> = 32

Do not load the tree in C<$h-E<gt>aug_init>.

=back

To close the handle, you can call C<$h-E<gt>aug_close>.

To find out more about Augeas, see L<http://augeas.net/>.

=item $h->aug_insert ($path, $label, $before);

Create a new sibling C<label> for C<path>, inserting it into
the tree before or after C<path> (depending on the boolean
flag C<before>).

C<path> must match exactly one existing node in the tree, and
C<label> must be a label, ie. not contain C</>, C<*> or end
with a bracketed index C<[N]>.

=item $h->aug_load ();

Load files into the tree.

See C<aug_load> in the Augeas documentation for the full gory
details.

=item @matches = $h->aug_ls ($path);

This is just a shortcut for listing C<$h-E<gt>aug_match>
C<path/*> and sorting the resulting nodes into alphabetical order.

=item @matches = $h->aug_match ($path);

Returns a list of paths which match the path expression C<path>.
The returned paths are sufficiently qualified so that they match
exactly one node in the current tree.

=item $h->aug_mv ($src, $dest);

Move the node C<src> to C<dest>.  C<src> must match exactly
one node.  C<dest> is overwritten if it exists.

=item $nrnodes = $h->aug_rm ($path);

Remove C<path> and all of its children.

On success this returns the number of entries which were removed.

=item $h->aug_save ();

This writes all pending changes to disk.

The flags which were passed to C<$h-E<gt>aug_init> affect exactly
how files are saved.

=item $h->aug_set ($path, $val);

Set the value associated with C<path> to C<value>.

=item $h->blockdev_flushbufs ($device);

This tells the kernel to flush internal buffers associated
with C<device>.

This uses the L<blockdev(8)> command.

=item $blocksize = $h->blockdev_getbsz ($device);

This returns the block size of a device.

(Note this is different from both I<size in blocks> and
I<filesystem block size>).

This uses the L<blockdev(8)> command.

=item $ro = $h->blockdev_getro ($device);

Returns a boolean indicating if the block device is read-only
(true if read-only, false if not).

This uses the L<blockdev(8)> command.

=item $sizeinbytes = $h->blockdev_getsize64 ($device);

This returns the size of the device in bytes.

See also C<$h-E<gt>blockdev_getsz>.

This uses the L<blockdev(8)> command.

=item $sectorsize = $h->blockdev_getss ($device);

This returns the size of sectors on a block device.
Usually 512, but can be larger for modern devices.

(Note, this is not the size in sectors, use C<$h-E<gt>blockdev_getsz>
for that).

This uses the L<blockdev(8)> command.

=item $sizeinsectors = $h->blockdev_getsz ($device);

This returns the size of the device in units of 512-byte sectors
(even if the sectorsize isn't 512 bytes ... weird).

See also C<$h-E<gt>blockdev_getss> for the real sector size of
the device, and C<$h-E<gt>blockdev_getsize64> for the more
useful I<size in bytes>.

This uses the L<blockdev(8)> command.

=item $h->blockdev_rereadpt ($device);

Reread the partition table on C<device>.

This uses the L<blockdev(8)> command.

=item $h->blockdev_setbsz ($device, $blocksize);

This sets the block size of a device.

(Note this is different from both I<size in blocks> and
I<filesystem block size>).

This uses the L<blockdev(8)> command.

=item $h->blockdev_setro ($device);

Sets the block device named C<device> to read-only.

This uses the L<blockdev(8)> command.

=item $h->blockdev_setrw ($device);

Sets the block device named C<device> to read-write.

This uses the L<blockdev(8)> command.

=item $content = $h->cat ($path);

Return the contents of the file named C<path>.

Note that this function cannot correctly handle binary files
(specifically, files containing C<\0> character which is treated
as end of string).  For those you need to use the C<$h-E<gt>download>
function which has a more complex interface.

Because of the message protocol, there is a transfer limit 
of somewhere between 2MB and 4MB.  To transfer large files you should use
FTP.

=item $checksum = $h->checksum ($csumtype, $path);

This call computes the MD5, SHAx or CRC checksum of the
file named C<path>.

The type of checksum to compute is given by the C<csumtype>
parameter which must have one of the following values:

=over 4

=item C<crc>

Compute the cyclic redundancy check (CRC) specified by POSIX
for the C<cksum> command.

=item C<md5>

Compute the MD5 hash (using the C<md5sum> program).

=item C<sha1>

Compute the SHA1 hash (using the C<sha1sum> program).

=item C<sha224>

Compute the SHA224 hash (using the C<sha224sum> program).

=item C<sha256>

Compute the SHA256 hash (using the C<sha256sum> program).

=item C<sha384>

Compute the SHA384 hash (using the C<sha384sum> program).

=item C<sha512>

Compute the SHA512 hash (using the C<sha512sum> program).

=back

The checksum is returned as a printable string.

=item $h->chmod ($mode, $path);

Change the mode (permissions) of C<path> to C<mode>.  Only
numeric modes are supported.

=item $h->chown ($owner, $group, $path);

Change the file owner to C<owner> and group to C<group>.

Only numeric uid and gid are supported.  If you want to use
names, you will need to locate and parse the password file
yourself (Augeas support makes this relatively easy).

=item $output = $h->command (\@arguments);

This call runs a command from the guest filesystem.  The
filesystem must be mounted, and must contain a compatible
operating system (ie. something Linux, with the same
or compatible processor architecture).

The single parameter is an argv-style list of arguments.
The first element is the name of the program to run.
Subsequent elements are parameters.  The list must be
non-empty (ie. must contain a program name).

The return value is anything printed to I<stdout> by
the command.

If the command returns a non-zero exit status, then
this function returns an error message.  The error message
string is the content of I<stderr> from the command.

The C<$PATH> environment variable will contain at least
C</usr/bin> and C</bin>.  If you require a program from
another location, you should provide the full path in the
first parameter.

Shared libraries and data files required by the program
must be available on filesystems which are mounted in the
correct places.  It is the caller's responsibility to ensure
all filesystems that are needed are mounted at the right
locations.

Because of the message protocol, there is a transfer limit 
of somewhere between 2MB and 4MB.  To transfer large files you should use
FTP.

=item @lines = $h->command_lines (\@arguments);

This is the same as C<$h-E<gt>command>, but splits the
result into a list of lines.

Because of the message protocol, there is a transfer limit 
of somewhere between 2MB and 4MB.  To transfer large files you should use
FTP.

=item $h->config ($qemuparam, $qemuvalue);

This can be used to add arbitrary qemu command line parameters
of the form C<-param value>.  Actually it's not quite arbitrary - we
prevent you from setting some parameters which would interfere with
parameters that we use.

The first character of C<param> string must be a C<-> (dash).

C<value> can be NULL.

=item $h->cp ($src, $dest);

This copies a file from C<src> to C<dest> where C<dest> is
either a destination filename or destination directory.

=item $h->cp_a ($src, $dest);

This copies a file or directory from C<src> to C<dest>
recursively using the C<cp -a> command.

=item $result = $h->debug ($subcmd, \@extraargs);

The C<$h-E<gt>debug> command exposes some internals of
C<guestfsd> (the guestfs daemon) that runs inside the
qemu subprocess.

There is no comprehensive help for this command.  You have
to look at the file C<daemon/debug.c> in the libguestfs source
to find out what you can do.

=item $kmsgs = $h->dmesg ();

This returns the kernel messages (C<dmesg> output) from
the guest kernel.  This is sometimes useful for extended
debugging of problems.

Another way to get the same information is to enable
verbose messages with C<$h-E<gt>set_verbose> or by setting
the environment variable C<LIBGUESTFS_DEBUG=1> before
running the program.

=item $h->download ($remotefilename, $filename);

Download file C<remotefilename> and save it as C<filename>
on the local machine.

C<filename> can also be a named pipe.

See also C<$h-E<gt>upload>, C<$h-E<gt>cat>.

=item $h->drop_caches ($whattodrop);

This instructs the guest kernel to drop its page cache,
and/or dentries and inode caches.  The parameter C<whattodrop>
tells the kernel what precisely to drop, see
L<http://linux-mm.org/Drop_Caches>

Setting C<whattodrop> to 3 should drop everything.

This automatically calls L<sync(2)> before the operation,
so that the maximum guest memory is freed.

=item $h->end_busy ();

This sets the state to C<READY>, or if in C<CONFIG> then it leaves the
state as is.  This is only used when implementing
actions using the low-level API.

For more information on states, see L<guestfs(3)>.

=item $equality = $h->equal ($file1, $file2);

This compares the two files C<file1> and C<file2> and returns
true if their content is exactly equal, or false otherwise.

The external L<cmp(1)> program is used for the comparison.

=item $existsflag = $h->exists ($path);

This returns C<true> if and only if there is a file, directory
(or anything) with the given C<path> name.

See also C<$h-E<gt>is_file>, C<$h-E<gt>is_dir>, C<$h-E<gt>stat>.

=item $description = $h->file ($path);

This call uses the standard L<file(1)> command to determine
the type or contents of the file.  This also works on devices,
for example to find out whether a partition contains a filesystem.

The exact command which runs is C<file -bsL path>.  Note in
particular that the filename is not prepended to the output
(the C<-b> option).

=item @names = $h->find ($directory);

This command lists out all files and directories, recursively,
starting at C<directory>.  It is essentially equivalent to
running the shell command C<find directory -print> but some
post-processing happens on the output, described below.

This returns a list of strings I<without any prefix>.  Thus
if the directory structure was:

 /tmp/a
 /tmp/b
 /tmp/c/d

then the returned list from C<$h-E<gt>find> C</tmp> would be
4 elements:

 a
 b
 c
 c/d

If C<directory> is not a directory, then this command returns
an error.

The returned list is sorted.

=item $status = $h->fsck ($fstype, $device);

This runs the filesystem checker (fsck) on C<device> which
should have filesystem type C<fstype>.

The returned integer is the status.  See L<fsck(8)> for the
list of status codes from C<fsck>.

Notes:

=over 4

=item *

Multiple status codes can be summed together.

=item *

A non-zero return code can mean "success", for example if
errors have been corrected on the filesystem.

=item *

Checking or repairing NTFS volumes is not supported
(by linux-ntfs).

=back

This command is entirely equivalent to running C<fsck -a -t fstype device>.

=item $append = $h->get_append ();

Return the additional kernel options which are added to the
guest kernel command line.

If C<NULL> then no options are added.

=item $autosync = $h->get_autosync ();

Get the autosync flag.

=item $label = $h->get_e2label ($device);

This returns the ext2/3/4 filesystem label of the filesystem on
C<device>.

=item $uuid = $h->get_e2uuid ($device);

This returns the ext2/3/4 filesystem UUID of the filesystem on
C<device>.

=item $path = $h->get_path ();

Return the current search path.

This is always non-NULL.  If it wasn't set already, then this will
return the default path.

=item $qemu = $h->get_qemu ();

Return the current qemu binary.

This is always non-NULL.  If it wasn't set already, then this will
return the default qemu binary name.

=item $state = $h->get_state ();

This returns the current state as an opaque integer.  This is
only useful for printing debug and internal error messages.

For more information on states, see L<guestfs(3)>.

=item $verbose = $h->get_verbose ();

This returns the verbose messages flag.

=item $h->grub_install ($root, $device);

This command installs GRUB (the Grand Unified Bootloader) on
C<device>, with the root directory being C<root>.

=item $dump = $h->hexdump ($path);

This runs C<hexdump -C> on the given C<path>.  The result is
the human-readable, canonical hex dump of the file.

Because of the message protocol, there is a transfer limit 
of somewhere between 2MB and 4MB.  To transfer large files you should use
FTP.

=item $busy = $h->is_busy ();

This returns true iff this handle is busy processing a command
(in the C<BUSY> state).

For more information on states, see L<guestfs(3)>.

=item $config = $h->is_config ();

This returns true iff this handle is being configured
(in the C<CONFIG> state).

For more information on states, see L<guestfs(3)>.

=item $dirflag = $h->is_dir ($path);

This returns C<true> if and only if there is a directory
with the given C<path> name.  Note that it returns false for
other objects like files.

See also C<$h-E<gt>stat>.

=item $fileflag = $h->is_file ($path);

This returns C<true> if and only if there is a file
with the given C<path> name.  Note that it returns false for
other objects like directories.

See also C<$h-E<gt>stat>.

=item $launching = $h->is_launching ();

This returns true iff this handle is launching the subprocess
(in the C<LAUNCHING> state).

For more information on states, see L<guestfs(3)>.

=item $ready = $h->is_ready ();

This returns true iff this handle is ready to accept commands
(in the C<READY> state).

For more information on states, see L<guestfs(3)>.

=item $h->kill_subprocess ();

This kills the qemu subprocess.  You should never need to call this.

=item $h->launch ();

Internally libguestfs is implemented by running a virtual machine
using L<qemu(1)>.

You should call this after configuring the handle
(eg. adding drives) but before performing any actions.

=item @devices = $h->list_devices ();

List all the block devices.

The full block device names are returned, eg. C</dev/sda>

=item @partitions = $h->list_partitions ();

List all the partitions detected on all block devices.

The full partition device names are returned, eg. C</dev/sda1>

This does not return logical volumes.  For that you will need to
call C<$h-E<gt>lvs>.

=item $listing = $h->ll ($directory);

List the files in C<directory> (relative to the root directory,
there is no cwd) in the format of 'ls -la'.

This command is mostly useful for interactive sessions.  It
is I<not> intended that you try to parse the output string.

=item @listing = $h->ls ($directory);

List the files in C<directory> (relative to the root directory,
there is no cwd).  The '.' and '..' entries are not returned, but
hidden files are shown.

This command is mostly useful for interactive sessions.  Programs
should probably use C<$h-E<gt>readdir> instead.

=item %statbuf = $h->lstat ($path);

Returns file information for the given C<path>.

This is the same as C<$h-E<gt>stat> except that if C<path>
is a symbolic link, then the link is stat-ed, not the file it
refers to.

This is the same as the C<lstat(2)> system call.

=item $h->lvcreate ($logvol, $volgroup, $mbytes);

This creates an LVM volume group called C<logvol>
on the volume group C<volgroup>, with C<size> megabytes.

=item $h->lvm_remove_all ();

This command removes all LVM logical volumes, volume groups
and physical volumes.

B<This command is dangerous.  Without careful use you
can easily destroy all your data>.

=item $h->lvremove ($device);

Remove an LVM logical volume C<device>, where C<device> is
the path to the LV, such as C</dev/VG/LV>.

You can also remove all LVs in a volume group by specifying
the VG name, C</dev/VG>.

=item $h->lvresize ($device, $mbytes);

This resizes (expands or shrinks) an existing LVM logical
volume to C<mbytes>.  When reducing, data in the reduced part
is lost.

=item @logvols = $h->lvs ();

List all the logical volumes detected.  This is the equivalent
of the L<lvs(8)> command.

This returns a list of the logical volume device names
(eg. C</dev/VolGroup00/LogVol00>).

See also C<$h-E<gt>lvs_full>.

=item @logvols = $h->lvs_full ();

List all the logical volumes detected.  This is the equivalent
of the L<lvs(8)> command.  The "full" version includes all fields.

=item $h->mkdir ($path);

Create a directory named C<path>.

=item $h->mkdir_p ($path);

Create a directory named C<path>, creating any parent directories
as necessary.  This is like the C<mkdir -p> shell command.

=item $h->mkfs ($fstype, $device);

This creates a filesystem on C<device> (usually a partition
or LVM logical volume).  The filesystem type is C<fstype>, for
example C<ext3>.

=item $h->mount ($device, $mountpoint);

Mount a guest disk at a position in the filesystem.  Block devices
are named C</dev/sda>, C</dev/sdb> and so on, as they were added to
the guest.  If those block devices contain partitions, they will have
the usual names (eg. C</dev/sda1>).  Also LVM C</dev/VG/LV>-style
names can be used.

The rules are the same as for L<mount(2)>:  A filesystem must
first be mounted on C</> before others can be mounted.  Other
filesystems can only be mounted on directories which already
exist.

The mounted filesystem is writable, if we have sufficient permissions
on the underlying device.

The filesystem options C<sync> and C<noatime> are set with this
call, in order to improve reliability.

=item $h->mount_options ($options, $device, $mountpoint);

This is the same as the C<$h-E<gt>mount> command, but it
allows you to set the mount options as for the
L<mount(8)> I<-o> flag.

=item $h->mount_ro ($device, $mountpoint);

This is the same as the C<$h-E<gt>mount> command, but it
mounts the filesystem with the read-only (I<-o ro>) flag.

=item $h->mount_vfs ($options, $vfstype, $device, $mountpoint);

This is the same as the C<$h-E<gt>mount> command, but it
allows you to set both the mount options and the vfstype
as for the L<mount(8)> I<-o> and I<-t> flags.

=item @devices = $h->mounts ();

This returns the list of currently mounted filesystems.  It returns
the list of devices (eg. C</dev/sda1>, C</dev/VG/LV>).

Some internal mounts are not shown.

=item $h->mv ($src, $dest);

This moves a file from C<src> to C<dest> where C<dest> is
either a destination filename or destination directory.

=item $h->ping_daemon ();

This is a test probe into the guestfs daemon running inside
the qemu subprocess.  Calling this function checks that the
daemon responds to the ping message, without affecting the daemon
or attached block device(s) in any other way.

=item $h->pvcreate ($device);

This creates an LVM physical volume on the named C<device>,
where C<device> should usually be a partition name such
as C</dev/sda1>.

=item $h->pvremove ($device);

This wipes a physical volume C<device> so that LVM will no longer
recognise it.

The implementation uses the C<pvremove> command which refuses to
wipe physical volumes that contain any volume groups, so you have
to remove those first.

=item $h->pvresize ($device);

This resizes (expands or shrinks) an existing LVM physical
volume to match the new size of the underlying device.

=item @physvols = $h->pvs ();

List all the physical volumes detected.  This is the equivalent
of the L<pvs(8)> command.

This returns a list of just the device names that contain
PVs (eg. C</dev/sda2>).

See also C<$h-E<gt>pvs_full>.

=item @physvols = $h->pvs_full ();

List all the physical volumes detected.  This is the equivalent
of the L<pvs(8)> command.  The "full" version includes all fields.

=item @lines = $h->read_lines ($path);

Return the contents of the file named C<path>.

The file contents are returned as a list of lines.  Trailing
C<LF> and C<CRLF> character sequences are I<not> returned.

Note that this function cannot correctly handle binary files
(specifically, files containing C<\0> character which is treated
as end of line).  For those you need to use the C<$h-E<gt>read_file>
function which has a more complex interface.

=item $h->resize2fs ($device);

This resizes an ext2 or ext3 filesystem to match the size of
the underlying device.

=item $h->rm ($path);

Remove the single file C<path>.

=item $h->rm_rf ($path);

Remove the file or directory C<path>, recursively removing the
contents if its a directory.  This is like the C<rm -rf> shell
command.

=item $h->rmdir ($path);

Remove the single directory C<path>.

=item $h->set_append ($append);

This function is used to add additional options to the
guest kernel command line.

The default is C<NULL> unless overridden by setting
C<LIBGUESTFS_APPEND> environment variable.

Setting C<append> to C<NULL> means I<no> additional options
are passed (libguestfs always adds a few of its own).

=item $h->set_autosync ($autosync);

If C<autosync> is true, this enables autosync.  Libguestfs will make a
best effort attempt to run C<$h-E<gt>umount_all> followed by
C<$h-E<gt>sync> when the handle is closed
(also if the program exits without closing handles).

This is disabled by default (except in guestfish where it is
enabled by default).

=item $h->set_busy ();

This sets the state to C<BUSY>.  This is only used when implementing
actions using the low-level API.

For more information on states, see L<guestfs(3)>.

=item $h->set_e2label ($device, $label);

This sets the ext2/3/4 filesystem label of the filesystem on
C<device> to C<label>.  Filesystem labels are limited to
16 characters.

You can use either C<$h-E<gt>tune2fs_l> or C<$h-E<gt>get_e2label>
to return the existing label on a filesystem.

=item $h->set_e2uuid ($device, $uuid);

This sets the ext2/3/4 filesystem UUID of the filesystem on
C<device> to C<uuid>.  The format of the UUID and alternatives
such as C<clear>, C<random> and C<time> are described in the
L<tune2fs(8)> manpage.

You can use either C<$h-E<gt>tune2fs_l> or C<$h-E<gt>get_e2uuid>
to return the existing UUID of a filesystem.

=item $h->set_path ($path);

Set the path that libguestfs searches for kernel and initrd.img.

The default is C<$libdir/guestfs> unless overridden by setting
C<LIBGUESTFS_PATH> environment variable.

Setting C<path> to C<NULL> restores the default path.

=item $h->set_qemu ($qemu);

Set the qemu binary that we will use.

The default is chosen when the library was compiled by the
configure script.

You can also override this by setting the C<LIBGUESTFS_QEMU>
environment variable.

Setting C<qemu> to C<NULL> restores the default qemu binary.

=item $h->set_ready ();

This sets the state to C<READY>.  This is only used when implementing
actions using the low-level API.

For more information on states, see L<guestfs(3)>.

=item $h->set_verbose ($verbose);

If C<verbose> is true, this turns on verbose messages (to C<stderr>).

Verbose messages are disabled unless the environment variable
C<LIBGUESTFS_DEBUG> is defined and set to C<1>.

=item $h->sfdisk ($device, $cyls, $heads, $sectors, \@lines);

This is a direct interface to the L<sfdisk(8)> program for creating
partitions on block devices.

C<device> should be a block device, for example C</dev/sda>.

C<cyls>, C<heads> and C<sectors> are the number of cylinders, heads
and sectors on the device, which are passed directly to sfdisk as
the I<-C>, I<-H> and I<-S> parameters.  If you pass C<0> for any
of these, then the corresponding parameter is omitted.  Usually for
'large' disks, you can just pass C<0> for these, but for small
(floppy-sized) disks, sfdisk (or rather, the kernel) cannot work
out the right geometry and you will need to tell it.

C<lines> is a list of lines that we feed to C<sfdisk>.  For more
information refer to the L<sfdisk(8)> manpage.

To create a single partition occupying the whole disk, you would
pass C<lines> as a single element list, when the single element being
the string C<,> (comma).

See also: C<$h-E<gt>sfdisk_l>, C<$h-E<gt>sfdisk_N>

B<This command is dangerous.  Without careful use you
can easily destroy all your data>.

=item $h->sfdisk_N ($device, $n, $cyls, $heads, $sectors, $line);

This runs L<sfdisk(8)> option to modify just the single
partition C<n> (note: C<n> counts from 1).

For other parameters, see C<$h-E<gt>sfdisk>.  You should usually
pass C<0> for the cyls/heads/sectors parameters.

B<This command is dangerous.  Without careful use you
can easily destroy all your data>.

=item $partitions = $h->sfdisk_disk_geometry ($device);

This displays the disk geometry of C<device> read from the
partition table.  Especially in the case where the underlying
block device has been resized, this can be different from the
kernel's idea of the geometry (see C<$h-E<gt>sfdisk_kernel_geometry>).

The result is in human-readable format, and not designed to
be parsed.

=item $partitions = $h->sfdisk_kernel_geometry ($device);

This displays the kernel's idea of the geometry of C<device>.

The result is in human-readable format, and not designed to
be parsed.

=item $partitions = $h->sfdisk_l ($device);

This displays the partition table on C<device>, in the
human-readable output of the L<sfdisk(8)> command.  It is
not intended to be parsed.

=item %statbuf = $h->stat ($path);

Returns file information for the given C<path>.

This is the same as the C<stat(2)> system call.

=item %statbuf = $h->statvfs ($path);

Returns file system statistics for any mounted file system.
C<path> should be a file or directory in the mounted file system
(typically it is the mount point itself, but it doesn't need to be).

This is the same as the C<statvfs(2)> system call.

=item @stringsout = $h->strings ($path);

This runs the L<strings(1)> command on a file and returns
the list of printable strings found.

Because of the message protocol, there is a transfer limit 
of somewhere between 2MB and 4MB.  To transfer large files you should use
FTP.

=item @stringsout = $h->strings_e ($encoding, $path);

This is like the C<$h-E<gt>strings> command, but allows you to
specify the encoding.

See the L<strings(1)> manpage for the full list of encodings.

Commonly useful encodings are C<l> (lower case L) which will
show strings inside Windows/x86 files.

The returned strings are transcoded to UTF-8.

Because of the message protocol, there is a transfer limit 
of somewhere between 2MB and 4MB.  To transfer large files you should use
FTP.

=item $h->sync ();

This syncs the disk, so that any writes are flushed through to the
underlying disk image.

You should always call this if you have modified a disk image, before
closing the handle.

=item $h->tar_in ($tarfile, $directory);

This command uploads and unpacks local file C<tarfile> (an
I<uncompressed> tar file) into C<directory>.

To upload a compressed tarball, use C<$h-E<gt>tgz_in>.

=item $h->tar_out ($directory, $tarfile);

This command packs the contents of C<directory> and downloads
it to local file C<tarfile>.

To download a compressed tarball, use C<$h-E<gt>tgz_out>.

=item $h->tgz_in ($tarball, $directory);

This command uploads and unpacks local file C<tarball> (a
I<gzip compressed> tar file) into C<directory>.

To upload an uncompressed tarball, use C<$h-E<gt>tar_in>.

=item $h->tgz_out ($directory, $tarball);

This command packs the contents of C<directory> and downloads
it to local file C<tarball>.

To download an uncompressed tarball, use C<$h-E<gt>tar_out>.

=item $h->touch ($path);

Touch acts like the L<touch(1)> command.  It can be used to
update the timestamps on a file, or, if the file does not exist,
to create a new zero-length file.

=item %superblock = $h->tune2fs_l ($device);

This returns the contents of the ext2, ext3 or ext4 filesystem
superblock on C<device>.

It is the same as running C<tune2fs -l device>.  See L<tune2fs(8)>
manpage for more details.  The list of fields returned isn't
clearly defined, and depends on both the version of C<tune2fs>
that libguestfs was built against, and the filesystem itself.

=item $h->umount ($pathordevice);

This unmounts the given filesystem.  The filesystem may be
specified either by its mountpoint (path) or the device which
contains the filesystem.

=item $h->umount_all ();

This unmounts all mounted filesystems.

Some internal mounts are not unmounted by this call.

=item $h->upload ($filename, $remotefilename);

Upload local file C<filename> to C<remotefilename> on the
filesystem.

C<filename> can also be a named pipe.

See also C<$h-E<gt>download>.

=item $h->vg_activate ($activate, \@volgroups);

This command activates or (if C<activate> is false) deactivates
all logical volumes in the listed volume groups C<volgroups>.
If activated, then they are made known to the
kernel, ie. they appear as C</dev/mapper> devices.  If deactivated,
then those devices disappear.

This command is the same as running C<vgchange -a y|n volgroups...>

Note that if C<volgroups> is an empty list then B<all> volume groups
are activated or deactivated.

=item $h->vg_activate_all ($activate);

This command activates or (if C<activate> is false) deactivates
all logical volumes in all volume groups.
If activated, then they are made known to the
kernel, ie. they appear as C</dev/mapper> devices.  If deactivated,
then those devices disappear.

This command is the same as running C<vgchange -a y|n>

=item $h->vgcreate ($volgroup, \@physvols);

This creates an LVM volume group called C<volgroup>
from the non-empty list of physical volumes C<physvols>.

=item $h->vgremove ($vgname);

Remove an LVM volume group C<vgname>, (for example C<VG>).

This also forcibly removes all logical volumes in the volume
group (if any).

=item @volgroups = $h->vgs ();

List all the volumes groups detected.  This is the equivalent
of the L<vgs(8)> command.

This returns a list of just the volume group names that were
detected (eg. C<VolGroup00>).

See also C<$h-E<gt>vgs_full>.

=item @volgroups = $h->vgs_full ();

List all the volumes groups detected.  This is the equivalent
of the L<vgs(8)> command.  The "full" version includes all fields.

=item $h->wait_ready ();

Internally libguestfs is implemented by running a virtual machine
using L<qemu(1)>.

You should call this after C<$h-E<gt>launch> to wait for the launch
to complete.

=item $h->write_file ($path, $content, $size);

This call creates a file called C<path>.  The contents of the
file is the string C<content> (which can contain any 8 bit data),
with length C<size>.

As a special case, if C<size> is C<0>
then the length is calculated using C<strlen> (so in this case
the content cannot contain embedded ASCII NULs).

I<NB.> Owing to a bug, writing content containing ASCII NUL
characters does I<not> work, even if the length is specified.
We hope to resolve this bug in a future version.  In the meantime
use C<$h-E<gt>upload>.

Because of the message protocol, there is a transfer limit 
of somewhere between 2MB and 4MB.  To transfer large files you should use
FTP.

=item $h->zero ($device);

This command writes zeroes over the first few blocks of C<device>.

How many blocks are zeroed isn't specified (but it's I<not> enough
to securely wipe the device).  It should be sufficient to remove
any partition tables, filesystem superblocks and so on.

=item $h->zerofree ($device);

This runs the I<zerofree> program on C<device>.  This program
claims to zero unused inodes and disk blocks on an ext2/3
filesystem, thus making it possible to compress the filesystem
more effectively.

You should B<not> run this program if the filesystem is
mounted.

It is possible that using this program can damage the filesystem
or data on the filesystem.

=cut

1;

=back

=head1 COPYRIGHT

Copyright (C) 2009 Red Hat Inc.

=head1 LICENSE

Please see the file COPYING.LIB for the full license.

=head1 SEE ALSO

L<guestfs(3)>, L<guestfish(1)>.

=cut
