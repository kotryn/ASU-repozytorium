#!/usr/bin/perl

use File::Copy;
use strict;
use warnings;
 
sub write_report_i {
 	my ($text, $filename) = @_;

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

sub copy_folder_i {
    my ($from_dir, $to_dir, $to_dir2, $date) = @_;
    opendir my($dh), $from_dir or die "Could not open dir '$from_dir': $!";

    for my $entry (readdir $dh) {    
        next if $entry =~ /^\.$/;
        next if $entry =~ /^\..$/;
        
        my $source = "$from_dir/$entry";
        my $destination = "$to_dir/$entry";
        my $destination2 = "$to_dir2/$entry";
        if (-d $source) {
        	create_folder($destination);
        	create_folder($destination2);
            copy_folder_i($source, $destination, $destination2, $date);
        } else {
        	my $regex = $source =~ m/work\//;
        	if( -e $destination) {
			    #print "file $' exist\n";
			}else{
	            open (my $fc, ">", $destination) or die "Could not create file '$destination' $!";
		    	close $fc;
	            write_report_i("$'\n\n$date  - created", $destination);		
    		};
    		create_folder($destination2);
        }
    }
    closedir $dh;
    return;
}

sub create_folder {
	my ($dir) = @_;

	if (-d $dir) {
	    #print "folder $dir exist\n";
	}else{
		mkdir $dir or die "mkdir '$dir' failed: $!" if not -e $dir;
		print "created folder $dir\n";
	}
}

sub init {
	create_folder("archive");
	create_folder("archive/report");
	my $date = localtime();		

	if( -e "archive/report/all_data") {
	    #print "file archive/report/all_data exist\n";
	}else{
		open (my $fc, ">", "archive/report/all_data") or die "Could not create file 'archive/report/all_data' !";
		close $fc;
		write_report_i("all_data\n\nall_data $date - created\n", "archive/report/all_data");
	}

	copy_folder_i("work","archive/report", "archive", $date);
}
1;
 
