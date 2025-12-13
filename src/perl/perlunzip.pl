#!/usr/bin/env perl

=pod
Simple perl script to unzip one or more zip
files into a destionation directory.

Usage: $0 <zipfile1> [zipfile2...] <destination_dir>
=cut





use strict;
use warnings;

my $num_args =  @ARGV;

if ($num_args < 2) {
	die "Error: you must provide at least one ZIP file path and a destination path\n";
	"Usage: $0 <zipfile1> [zipfile2...] <destination_dir>\n";
}

my $dest_path = pop(@ARGV);

if ( ! -d $dest_path ) {
	if ( ! mkdir $dest_path, 0755 ) {
		die "Error: Could not create destination directory $dest_path: $!\n";
	}
}

foreach my $filepath (@ARGV) {
	print "Attempting to unzip: $filepath";
	# use the 'system' function to execute the standard 'unzip' utility.
	# the -q flah makes 'unzip' quiet, and the '$filepath' is passed as the target file.
	# the 'system' function returns 0 on success.
	my $exit_code = system('unzip', '-q', $filepath, "-d", "$dest_path");

	if ($exit_code == 0) {
		print "Successfully unzipped $filepath\n";
	} else {
		# 'system' returns the actual exit value of the command
		# shifted left by 8 bits, so we shift it back.
		my $unzip_exit_code = $exit_code >> 8;
		warn "ERROR: Unzip failed for $filepath. Exit code: $unzip_exit_code\n";
	}
}

