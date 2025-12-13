#!/bin/bash

set -euo pipefail

TEMP_LOG="/tmp/raw_log_$$"
FINAL_LOG_DIR="$HOME/.terminal_logs"
SESSION_JSON="$HOME/.terminal_json/session.jsonl"

mkdir -p "$FINAL_LOG_DIR" "$HOME/.terminal_json"

# Starts the recording
script -q "$TEMP_LOG"

# Process the log with Heredoc perl
perl - "$TEMP_LOG" "$FINAL_LOG_DIR" "$SESSION_JSON" << 'END_PERL'
use strict;
use warnings;
use POSIX qw(strftime);
use JSON::PP qw(encode_json);

my ($raw_file, $out_dir, $jsonl_path) = @ARGV; 

open (my $fh, '<', $raw_file ) or die "Could not open file: $!";
my $content = do { local $/; <$fh> };
close $fh;

$content =~ s/\x1b\[[0-9;]*m//g;
$content =~ s/^Script started on.*\n//m;
$content =~ s/^Script done.*\n//m;

my $ts = strftime("%Y%m%d_%H%M%S", localtime);
my $host = `hostname`; chomp $host;
my $out_path = "$out_dir/session_${host}_${ts}.log";

open my $out, '>', $out_path or die "Could not write $out_path: $!";
print {$out} $content;
close $out;

my %rec = (
	timestamp => $ts,
	host => $host,
	raw_file => $raw_file,
	log_file => $out_path,
	bytes => length($content),
);

open(my $jfh, '>>', $jsonl_path) or die "Could not append $jsonl_path: $!";
print {$jfh} encode_json(\%rec), "\n";
close $jfh;

print "Saved: $out_path\nIndexed: $jsonl_path\n";

END_PERL


echo "Logs saved succesfully."
rm -f "$TEMP_LOG"
