#!/usr/bin/perl

use File::Copy;
use strict;
use warnings;
require "init.pl";
 
sub write_report {
 	my ($text, $file) = @_;

 	my $filename = "archive/data/$file";

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

	open(my $ft, '>', $filename) or die "Could not open file '$filename' $!";
	print $ft @data;
	close $ft;
	print "done\n";	
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
            #write_report("$datestring  - copy $arg", $arg);
            print "---- $source\n";
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

	if (-d "archive/$arg") {
	    print "folder $arg exist\n";
	}else{
		mkdir ("archive/$arg") or die "The mkdir operation failed: $!";;
		print "created folder archive/$arg\n";
	}	





	

	my $datestring = localtime();
	my $new_dir = "archive/$arg/$datestring";

	if ($arg =~ /\//){
		$arg =~ /^(.*)\//;
		print "ooooooooooooooo $1\n";
	} 


	mkdir $new_dir or die "Not created $new_dir: $!";

	my $from = "work/$arg";

	if(-d "work/$arg"){
		copy_folder($from, $new_dir, $datestring);
		print "copied folder $arg in $new_dir\n";
	}else{
		print "$new_dir !!!!!!\n";
		copy_file($from, $new_dir);
		print "copied file $arg in $new_dir\n";

		write_report("$datestring  - copy $arg", $arg);
	}
}






