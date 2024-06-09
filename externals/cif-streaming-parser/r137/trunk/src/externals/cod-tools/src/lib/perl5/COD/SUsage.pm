#------------------------------------------------------------------------
#$Author: antanas $
#$Date: 2021-05-29 04:44:02 +0300 (Sat, 29 May 2021) $
#$Revision: 8806 $
#$URL: svn://cod.ibt.lt/cif-tools/trunk/src/lib/perl5/COD/SUsage.pm $
#------------------------------------------------------------------------
#*
#  Simple usage message generator.
#**

package COD::SUsage;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
    options
    usage
);

sub usage
{
    my $script = shift;
    $script = $0 unless defined $script;

    open my $script_fh, $script or
        die "$0: $script: ERROR, could not open the '$script' file for " .
            "reading -- " . lcfirst($!) . '.' . "\n";
    while( <$script_fh> ) {
        if( /^\s*#\*/ .. /^\s*#\*\*/ ) {
            /^\s*#\*?\*?/;
            my $line = "$'";
            $line =~ s/\$0/$0/g;
            print $line;
        }
    }
    close $script_fh or
        die "$0: $script: ERROR, error occurred while closing the '$script' " .
            "file after reading -- " . lcfirst($!) . '.' . "\n";

    return;
}

sub options
{
    my $script = shift;
    $script = $0 unless defined $script;

    print "$script: The '--options' option is a placeholder.\n";
    print "$script: It should be replaced by one of the following options:\n";
    open my $script_fh, $script or
        die "$0: $script: ERROR, could not open the '$script' file for " .
            "reading -- " . lcfirst($!) . '.' . "\n";
    while( <$script_fh> ) {
        if( /^#\*\s+OPTIONS:/../^#\*\*/ ) {
            s/^#\*\s+OPTIONS://;
            s/^#\*\*?//;
            s/\$0/$0/g;
            print;
        }
    }
    close $script_fh or
        die "$0: $script: ERROR, error occurred while closing the '$script' " .
            "file after reading -- " . lcfirst($!) . '.' . "\n";

    return;
}

1;
