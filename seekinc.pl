#/usr/bin/env perl
# Last modified: Mon Sep 02 2024 09:10:53 PM -04:00 [EDT]

=head1 NAME

seekinc.pl

=head1 SYNOPSIS

perl seekinc.pl

=cut

use warnings;
use strict;
use File::Find qw/ find /;
$File::Find::no_chdir=1;
my %hits;
my $base;

sub wanted() {
#   $_ is the current filename UNLESS we've done no_chdir
#   $File::Find::name is the complete pathfilename.
#   $File::Find::dir  is the current directory.
    $_ = $File::Find::name;
    if ( m{ / \w+\.p[ml] \Z }xs ) {
        for $base (@INC) {
			if (not -d $base) { $hits{$base} = "X"; next; }
		    $hits{$base} = 0 unless $hits{$base};
            if (-d $base and $_ =~m[^$base/.+])  {
                 $hits{$base}++;
	        }

        }
    }
}

for my $basepath (@INC) {
    find( \&wanted, $basepath );
}

for (keys %hits) {
    print sprintf('%-72s', $_), q[ ], $hits{$_} , qq[\n];
}


=pod

=head1 AUTHOR

Soren Andersen

=head1 VERSION

version 1.0

=head1 BUGS / TODO

No bugs that we know of.

=head1 COPYRIGHT

Copyright (c) 2024 Soren Andersen. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
