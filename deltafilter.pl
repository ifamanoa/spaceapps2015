#!/usr/bin/env perl

use FileHandle;

$lastobj = '';
$fh = undef;
$max_skip = 0;
while (defined($line = <STDIN>)) {
    my ($obj, $mjd, $delta) = split /\s+/, $line;
    if ($obj ne $lastobj) {
        $fh = new FileHandle ">$obj.dat" or die "cannot create $obj.dat";
        print STDERR "Creating $obj.dat.\n";
        $lastobj = $obj;
    }
    if ($delta > 999999) {
        if ($skip < $max_skip) {
            $skip++;
            if ($skip == $max_skip) {
                $skip = 0;
            }
        } 
    }
    else {
        $skip = 0;
    }
    if ($skip == 0) {
        print $fh "$mjd $delta\n";
    }
}
$fh->close;
