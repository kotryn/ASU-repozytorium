#!/usr/bin/perl -w
use strict;
use warnings;
 
sub write_report {
 	my ($text) = @_;
	my $filename = 'report.txt';
	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";
	my $a = 0;
	my @data = ();

	while (my $row = <$fh>) {
		$a = $a + 1;
	  	chomp $row;
	  	print "$a $row\n";
		push(@data, "$row\n");
	}	
	close $fh;

	push(@data, "$text\n");

	open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
	print $fh @data;
	close $fh;
	print "done\n";	
}

