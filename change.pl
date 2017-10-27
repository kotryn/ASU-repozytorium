#!/usr/bin/perl

use File::Copy;
use strict;
use warnings;

sub copy_folder {
    my ($from_dir, $to_dir) = @_;
    opendir my($dh), $from_dir or die "Could not open dir '$from_dir': $!";

    for my $entry (readdir $dh) {    
        next if $entry =~ /^\.$/;
        next if $entry =~ /^\..$/;
        
        my $source = "$from_dir/$entry";
        my $destination = "$to_dir/$entry";
        if (-d $source) {
            mkdir $destination or die "mkdir '$destination' failed: $!" if not -e $destination;
            copy_folder($source, $destination);
        } else {
            copy($source, $destination) or die "copy failed: $!";
        }
    }
    closedir $dh;
    return;
}

if( $#ARGV < 0){
	print "no arguments\n";
}else{
	my $i = 1;
	my $arg = "$ARGV[0]";
	while($i < $#ARGV+1){
		$arg = "$arg $ARGV[$i]";
		$i = $i + 1;
	}
	my $source = "$ARGV[0]";
	my @fields = split(/\//, $source);
	my $size = @fields;
	$i = 1;
	my $arg2 = "$fields[0]";
	while($i < $size-1){
		$arg2 = "$arg2/$fields[$i]";
		$i = $i + 1;
	}

	if(-f "work/$arg2"){
		@fields = split(/\//, "$arg2");
		$size = @fields;
		$i = 0;
		$arg2 = '';
		while($i < $size-1){
			$arg2 = "$arg2/$fields[$i]";
			$i = $i + 1;
		}
		print "done\n";
		copy_folder("archive/$arg", "work$arg2");

	}
	elsif(-d "work/$arg2"){
		copy_folder("archive/$arg", "work/$arg2");
		print "done\n";
	}else{
		print "incorect data\n";
	}		

}