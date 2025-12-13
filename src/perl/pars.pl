#/usr/bin/perl

use strict;
use warnings;

=begin comment
This Perl script follows convention to parse and log user-terminal
sessions. 

My initial goal was saving batch processes so I can 
analyze and train a loRa my terminal agent.

In a terminal, a simple background job or redirection comes down to
how interactive shell work versus batch processes.

**Background Problem**
When run a shell in the background ( `bash &`) it disconnects from
the keyboard. It has no way to receive the commands interactively.

**Redirection Problem**
`bash | tee log.txt` wont work as intended. They turn off colors,
progress bars, and sometimes even the prompt text itself 
because they might be a robot pipeline.

**PTY (Pseudo-Terminal)**
The solution is aggregating a man-in-the-middle with `script` command.
It inspects the process as the pseudo aggregater so we can save and decode
the processes separately.
=end comment
=cut

# Open the log file
open (my $fh, '<', 'my_log.txt' ) or die "Could not open file: $!";
# Read whole file at once
my $content = do { local $/; <$fh> };
# Remove ANSI color codes
$content =~ s/\x1b\[[0-9;]*m//g;
# Remove the process info lines
$content =~ s/Script started on.*\n//;
$content =~ s/Script done.*\n//;
# Print the clean verison
print $content;
