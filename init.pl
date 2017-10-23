#!/usr/bin/perl

use File::Copy;
use strict;
use warnings;
 
sub write_report {
 	my ($text, $filename) = @_;

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
        	create_folder($destination);
            copy_folder($source, $destination, $date);
        } else {
        	my $regex = $source =~ m/work\//;
        	if( -e $destination) {
			    print "$' exist\n";
			}else{
	            open (my $fc, ">", $destination) or die "Could not create file '$destination' $!";
		    	close $fc;
	            write_report("$'\n\n$date  - created", $destination);			
    		}
        }
    }
    closedir $dh;
    return;
}

sub create_folder {
	my ($dir) = @_;

	if (-d $dir) {
	    print "folder $dir exist\n";
	}else{
		mkdir $dir or die "mkdir '$dir' failed: $!" if not -e $dir;
		print "created folder $dir\n";
	}
}

create_folder("archive");
create_folder("archive/report");
my $date = localtime();		
copy_folder("work","archive/report", $date);

 
