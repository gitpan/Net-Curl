#!perl

use strict;
use warnings;
#use Test::More tests => 214;
use Test::More skip_all => "Not performing slow leakage regression test";

BEGIN { use_ok( 'Net::Curl::Easy' ); }
use Net::Curl::Easy qw(:constants);

my $url = $ENV{CURL_TEST_URL};

# There was a slow leak per curl handle init/cleanup. Hopefully fixed.

foreach my $j (1..200) {

# Init the curl session
my $curl = Net::Curl::Easy->new() or die "cannot curl";

$curl->setopt(CURLOPT_NOPROGRESS, 1);
$curl->setopt(CURLOPT_FOLLOWLOCATION, 1);
$curl->setopt(CURLOPT_TIMEOUT, 30);

open (HEAD, "+>",undef);
Net::Curl::Easy::setopt($curl, CURLOPT_WRITEHEADER, \*HEAD);
open (BODY, "+>", undef);
Net::Curl::Easy::setopt($curl, CURLOPT_FILE, \*BODY);

$curl->setopt(CURLOPT_URL, $url);
                                                                        
my $httpcode = 0;

eval { $curl->perform(); };
if ( not $@ ) {
	my bytes=$curl->getinfo(CURLINFO_SIZE_DOWNLOAD);
	my $realurl=$curl->getinfo(CURLINFO_EFFECTIVE_URL);
	my $httpcode=$curl->getinfo(CURLINFO_HTTP_CODE);
} else {
	print "not ok $retcode / ".$curl->error."\n";
} 

}

