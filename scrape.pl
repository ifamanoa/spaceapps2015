#!/usr/bin/env perl

# Turn an HTML table from the JPL risk page into a CSV list of impact
# solutions for a given asteroid.  There should not be a space in the 
# name, e.g. 2015BR12.

# This script is TOTALLY dependent on the format of the JPL HTML tables
# on the risk page.
$obj = shift @ARGV or die "Usage: $0 OBJECT\n";
$lcobj = $obj;
$lcobj =~ tr/A-Z/a-z/;
$url = "http://neo.jpl.nasa.gov/risks/$lcobj.html";
if ($url =~ /(\w+)\.html$/) {
    $me = $1;
    $me =~ tr/a-z/A-Z/;
} else {
    die "Weird URL: $url\n";
}
$stuff = join('', `curl -s $url`);     # all as one string
if (!$stuff) {
    die "No data for $obj using URL $url\n";
}

# Sub the heck out of it.
$stuff =~ s/\s+//g;                         # remove ALL whitespace
$stuff =~ s/^.*resultswerecomputed//;       # trim to approx beginning of table
$stuff =~ s/SummaryTableDescription.*//;    # trim after and of table

# Now break lines at <tr>
@stuff = split /<\/tr>/, $stuff;

# Accept only lines that have data.
@stuff = grep { /<tt>\d\d\d\d-\d\d-\d\d/ or /<b>Date/ } @stuff;

# Clean em up.
foreach (@stuff) {
    s/<td.*?>/\|/g;     # remove table tags
    s/<.*?>//g;         # remove all other tags
    s/&nbsp;//g;        # remove &nbsp; (non-breaking space)
    s/^\|/$me\|/;       # add leading object name
    s/\|/,/g;           # to CSV
}
$stuff[0] =~ s/^$me/Object/;        # hack first line

print join("\n", @stuff), "\n";     # output!
