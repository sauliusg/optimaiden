#------------------------------------------------------------------------
#$Author: antanas $
#$Date: 2021-04-28 17:11:36 +0300 (Wed, 28 Apr 2021) $
#$Revision: 8737 $
#$URL: svn://cod.ibt.lt/cif-tools/trunk/src/lib/perl5/COD/CIF/Tags/AMCSD.pm $
#------------------------------------------------------------------------
#*
#  A list of CIF dictionary tags used in AMCSD database.
#**

package COD::CIF::Tags::AMCSD;

use strict;
use warnings;

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw(
    @tag_list
);

our @tag_list = qw (
    _amcsd_formula_title
    _amcsd_database_code
    _amcsd_sample_locality
);

1;
