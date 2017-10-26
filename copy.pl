#!/usr/bin/perl

use File::Copy;
use strict;
use warnings;
require "init.pl";
 
sub write_report {
 	my ($text, $file) = @_;

 	my $filename = "archive/report/$file";

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";
	my @data = ();

	while (my $row = <$fh>) {
	  	chomp $row;
		push(@data, "$row\n");
	}	
	close $fh;

	push(@data, "$text\n");

	open(my $ft, '>', $filename) or die "Could not open file '$filename' $!";
	print $ft @data;
	close $ft;
}

sub copy_folder {
    my ($from_dir, $to_dir, $date) = @_;
    opendir my($dh), $from_dir or die "Could not open dir '$from_dir': $!";

    for my $entry (readdir $dh) {    
        next if $entry =~ /^\.$/;
        next if $entry =~ /^\..$/;
        
        my $source = "$from_dir/$entry";
        my $destination = "$to_dir/$entry";
        if (-d $source) {
            mkdir $destination or die "mkdir '$destination' failed: $!" if not -e $destination;
            copy_folder($source, $destination, $date);
        } else {
            copy($source, $destination) or die "copy failed: $!";
            my $regex = $source =~ m/work\//;
            write_report("$date  - created copy", $'); 
        }
    }
    closedir $dh;
    return;
}

sub copy_file {
	my ($original_file, $new_file) = @_;
	copy($original_file, $new_file) or die "The copy operation failed: $!";
}

init();

if( $#ARGV < 0){
	print "no arguments\n";
}else{
	my $arg = "$ARGV[0]";
	
	my $datestring = localtime();
	my $new_dir = "archive/$arg/$datestring";
	create_folder($new_dir);	

	my $from = "work/$arg";

	if(-d "work/$arg"){ #if $arg is folder
		copy_folder($from, $new_dir, $datestring);
		print "copied folder $arg in $new_dir\n";
	}

	else{#if $arg is file
		copy_file($from, $new_dir);
		print "copied file $arg in $new_dir\n";
		write_report("$datestring  - created copy", $arg);
	}
}