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

    diag "Running Perl version  $]\n";

    # use Test::NoWarnings, if available
    my $extra = 0 ;
    $extra = 1
        if eval { require Test::NoWarnings ;  import Test::NoWarnings; 1 };


    my $VERSION = '2.103';
    my @NAMES = qw(

			);

    my @OPT = qw(

			);

    plan tests => 1 + @NAMES + @OPT + $extra ;

    ok 1;

    foreach my $name (@NAMES)
    {
        use_ok($name, $VERSION);
    }


    foreach my $name (@OPT)
    {
        eval " require $name " ;
        if ($@)
        {
            ok 1, "$name not available"
        }
        else
        {
            my $ver = eval("\$${name}::VERSION");
            is $ver, $VERSION, "$name version should be $VERSION"
                or diag "$name version is $ver, need $VERSION" ;
        }
    }

}

{
    # Print our versions of all modules used

    my @results = ( [ 'perl', $] ] );
    my @modules = qw(
                    Compress::Raw::Zlib
                    );

    my %have = ();

    for my $module (@modules)
    {
        my $ver = packageVer($module) ;
        my $v = defined $ver
                    ? $ver
                    : "Not Installed" ;
        push @results, [$module, $v] ;
        $have{$module} ++
            if $ver ;
    }

    push @results, ["zlib_version", Compress::Raw::Zlib::zlib_version() ];
    no strict 'refs';
    push @results, ["ZLIB_VERNUM", sprintf("0x%x", &{ "Compress::Raw::Zlib::ZLIB_VERNUM" }) ];

    # my @z =
    if (Compress::Raw::Zlib::haveZlibNg())
    {
        push @results, ["zlib-ng", "Yes" ];

        my @ng = qw(
            ZLIBNG_VERSION
            ZLIBNG_VER_MAJOR
            ZLIBNG_VER_MINOR
            ZLIBNG_VER_REVISION
            ZLIBNG_VER_STATUS
            ZLIBNG_VER_MODIFIED
            );

        for my $n (@ng)
        {
            no strict 'refs';
            push @results, ["  $n", &{ "Compress::Raw::Zlib::$n" } ];
        }

        no strict 'refs';
        push @results, ["  ZLIBNG_VERNUM", sprintf("0x%x", &{ "Compress::Raw::Zlib::ZLIBNG_VERNUM" }) ];

    }
    else
    {
        push @results, ["zlib-ng", "No" ];
    }


    if ($have{"Compress::Raw::Lzma"})
    {
        my $ver = eval { Compress::Raw::Lzma::lzma_version_string(); } || "unknown";
        push @results, ["lzma", $ver] ;
    }

    use List::Util qw(max);
    my $width = max map { length $_->[0] } @results;

    diag "\n\n" ;
    for my $m (@results)
    {
        my ($name, $ver) = @$m;

        my $b = " " x (1 + $width - length $name);

        diag $name . $b . $ver . "\n" ;
    }

    diag "\n\n" ;
}

sub packageVer
{
    no strict 'refs';
    my $package = shift;

    eval "use $package;";
    return ${ "${package}::VERSION" };

}