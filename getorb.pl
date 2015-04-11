#!/usr/bin/env perl

# Create a list of risk asteroid orbital elements from "ast.des",
# the DES-formatted JPL object list.  Pipe this to risk.des.

while ($line = <STDIN>) {
    chomp $line;
    ($desig, @foo) = split /,/, $line;

    # If desig contains "(", it's numbered.  If not, it's a 
    # standard MPC YEAR-SUFFIX desig.
    if ($desig =~ /\(/) {
        if ($desig =~ /^(\d+)\s+/) {
            $desig = $1;
        }
        else {
            print STDERR "Weird desig: $desig\n";
        }
    }
    else {
        $desig =~ s/\s+//g; # strip all spaces
    }
    system qq{grep -w "^$desig" ast.des};
}
