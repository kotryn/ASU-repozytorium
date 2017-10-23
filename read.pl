#!/usr/bin/perl

use File::Copy;
use strict;
use warnings;
 
sub read_history {
 	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	while (my $row = <$fh>) {
	  	chomp $row;
		print "$row\n";
	}	
	close $fh;

	
}

if( $#ARGV < 0){
	print "no arguments\n";
}else{
	my $arg = "$ARGV[0]";
	my $dist = "archive/report/$arg";

	if( -f $dist) {
    	read_history($dist);
	}else{
		print "It's not a file\n";
	}

}	