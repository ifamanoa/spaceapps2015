#!/usr/bin/env perl

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

# sub the crap out of it.
# 1. Remove all whitespace.
$stuff =~ s/\s+//g;
$stuff =~ s/^.*resultswerecomputed//;
$stuff =~ s/SummaryTableDescription.*//;

@stuff = split /<\/tr>/, $stuff;
@stuff = grep { /<tt>\d\d\d\d-\d\d-\d\d/ or /<b>Date/ } @stuff;

foreach (@stuff) {
    s/<td.*?>/\|/g;
    s/<.*?>//g;
    s/&nbsp;//g;
    s/^\|/$me\|/;
    s/\|/,/g;
}
$stuff[0] =~ s/^$me/Object/;

print join("\n", @stuff), "\n";
