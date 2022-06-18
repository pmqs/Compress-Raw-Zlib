BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib qw(t t/compress);
use strict ;
use warnings ;

use Test::More ;

BEGIN
{
    # use Test::NoWarnings, if available
    my $extra = 0 ;
    $extra = 1
        if eval { require Test::NoWarnings ;  import Test::NoWarnings; 1 };

    plan tests => 2 + $extra ;

    use_ok('Compress::Raw::Zlib', 2) ;
}

use CompTestUtils;


# Check zlib_version and ZLIB_VERSION are the same.

test_zlib_header_matches_library();
