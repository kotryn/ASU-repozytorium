#!/usr/bin/perl

use File::Copy;
use strict;
use warnings;
 
sub delete_history {
 	my ($filename) = @_;

	open(my $ft, '>', $filename) or die "Could not open file '$filename' $!";
	print $ft "";
	close $ft;
}

if( $#ARGV < 0){
	print "no arguments\n";
}else{
	my $arg = "$ARGV[0]";
	my $dist = "archive/report/$arg";

	if( -f $dist) {
    	delete_history($dist);
	}else{
		print "It's not a file\n";
	}
}	