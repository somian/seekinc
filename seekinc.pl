#/usr/bin/env perl
# Last modified: Sat Aug 31 2024 09:30:10 PM -04:00 [EDT]

# Name: seekinc.pl
use warnings;
use strict;
use File::Find qw/ find /;
$File::Find::no_chdir=1;
my %hits;
my $extent; my $base;

sub wanted() {
#   $_ is the current filename UNLESS we've done no_chdir
#   $File::Find::name is the complete pathfilename.
#   $File::Find::dir  is the current directory.
    $_ = $File::Find::name;
    if ( m{ / \w+\.p[ml] \Z }xs ) {
        for $base (@INC) {
             if ($_ =~m[^$base/.+])  {
                 $hits{$base}++;
                 last;
	     }
	elsif ( not exists $hits{$base} ) { $hits{$base} = 0; }
	}
    }
}

for my $basepath (@INC) {
    $extent = length $basepath;
    find( \&wanted, $basepath );

}

for (keys %hits) {
    print sprintf('%-72s', $_), q[ ], $hits{$_} , qq[\n];
}

