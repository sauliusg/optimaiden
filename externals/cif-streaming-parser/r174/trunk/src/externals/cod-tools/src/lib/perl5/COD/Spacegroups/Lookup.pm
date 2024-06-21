#------------------------------------------------------------------------
#$Author: antanas $
#$Date: 2022-07-28 13:57:58 +0300 (Thu, 28 Jul 2022) $
#$Revision: 9346 $
#$URL: svn://cod.ibt.lt/cif-tools/trunk/src/lib/perl5/COD/Spacegroups/Lookup.pm $
#------------------------------------------------------------------------
#*
#  Basic functions for space group look up.
#**

package COD::Spacegroups::Lookup;

use strict;
use warnings;

use COD::Spacegroups::Symop::Parse qw( symop_string_canonical_form );

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw(
    make_symop_key
    make_symop_hash
);

sub make_symop_key
{
    my ( $symops ) = @_;
    return join ';', sort map {symop_string_canonical_form($_)} @{$symops};
}

sub make_symop_hash
{
    my ( $space_group_sets ) = @_;

    return map { (make_symop_key($_->{symops}), $_) }
               map { @{$_} } @{$space_group_sets};
}

1;
