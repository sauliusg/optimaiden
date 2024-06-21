#------------------------------------------------------------------------------
#$Author: antanas $
#$Date: 2020-10-19 22:49:34 +0300 (Mon, 19 Oct 2020) $
#$Revision: 8554 $
#$URL: svn://cod.ibt.lt/cif-tools/trunk/src/lib/perl5/COD/CIF/DDL/Ranges.pm $
#------------------------------------------------------------------------------
#*
#* A set of subroutines for handling ranges as defined in the Dictionary
#* Definition Language (DDL) files.
#**

package COD::CIF::DDL::Ranges;

use strict;
use warnings;
use Scalar::Util qw( looks_like_number );

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw(
    parse_range
    range_to_string
    is_in_range
);

##
# Parse a DDL range string.
#
# @param $range_string
#       String specifying a range as defined in DDL.
# @return $range
#       A reference to an array of two element specifying the range.
#       The first element specifies the lower bound and the second element
#       specifies the upper bound. An undefined element signals that the
#       associated bound is not declared. Either of the elements can be
#       undefined.
##
sub parse_range
{
    my ($range_string) = @_;

    my @range = (undef, undef);
    if ($range_string =~ m/^([^:]+)?:([^:]+)?$/) {
        @range = ($1, $2);
    }

    return \@range;
}

##
# Construct a string representation of a range from the range array as
# returned by the COD::CIF::DDL::Ranges::parse_range() subroutine.
# The returned string does not have the same format as the range string
# found in DDL files and is mainly meant to be used in audit messages.
#
# @param $range
#       Reference to a range array as returned by the
#       COD::CIF::DDL::Ranges::parse_range() subroutine.
# @param $options
#       Reference to a hash of options. The following options are recognised:
#       {
#         # String representing the type of value ('numb' or 'char')
#           'type'  => 'char',
#       }
# @return $string
#       A string representing the enumeration range.
##
sub range_to_string
{
    my ($range, $options) = @_;

    my $type = defined $options->{'type'} ?
                       $options->{'type'} : 'char';
    my $string;
    if ( $type eq 'numb' ) {
        $string = range_to_string_numeric($range)
    } else {
        $string = range_to_string_char($range)
    }

    return $string;
}

##
# Construct a string representation of a numeric range from the range array
# as returned by the COD::CIF::DDL::Ranges::parse_range() subroutine.
# The returned string does not have the same format as the range string
# found in DDL files and is mainly meant to be used in audit messages.
#
# @param $range
#       Reference to a range array as returned by the
#       COD::CIF::DDL::Ranges::parse_range() subroutine.
# @return $string
#       A string representing a numeric enumeration range.
##
sub range_to_string_numeric
{
    my ($range) = @_;

    my $string;
    $string  = (defined $range->[0] ? "[$range->[0]" : '(-inf');
    $string .= ', ';
    $string .= (defined $range->[1] ? "$range->[1]]" : '+inf)');

    return $string;
}

##
# Construct a string representation of a character range from the range array
# as returned by the COD::CIF::DDL::Ranges::parse_range() subroutine.
# The returned string does not have the same format as the range string
# found in DDL files and is mainly meant to be used in audit messages.
#
# @param $range
#       Reference to a range array as returned by the
#       COD::CIF::DDL::Ranges::parse_range() subroutine.
# @return $string
#       A string representing a character enumeration range.
##
sub range_to_string_char
{
    my ($range) = @_;

    my $string;
    $string  = (defined $range->[0] ? "['$range->[0]'" : '[<any>');
    $string .= ', ';
    $string .= (defined $range->[1] ? "'$range->[1]']" : '<any>]');

    return $string;
}

##
# Check value against range (defined in dictionary).
#
# @param $value
#       Value to be checked.
# @param $param
#       Parameter hash with the following keys:
#       {
#         # String, representing the type of value ('numb' or 'char').
#         # Default: 'char'
#           'type'  => 'char',
#         # Reference to a range array as returned by the
#         # COD::CIF::DDL::Ranges::parse_range() subroutine
#           'range' => [0, 10],
#         # Standard uncertainty (s.u.) to be used when determining
#         # if a numeric value resides in the specified range.
#         # See the is_in_range_numeric() subroutine for more details
#           'sigma' => 0.1,
#         # Multiplier that should be applied to the standard
#         # uncertainty (s.u.) when determining if a numeric
#         # value resides in the specified range. See the
#         # is_in_range_numeric() subroutine for more details.
#         # Default: 3
#           'multiplier' => 3,
#         }
# @return
#       -1 if no ranges were provided for the value;
#        0 if the value is out of the provided range;
#        1 if the value is in the provided range.
##
sub is_in_range
{
    my ( $value, $param ) = @_;

    my $range = $param->{'range'};
    my $type  = defined $param->{'type'} ?
                        $param->{'type'} : 'char';
    my $su_multiplier = defined $param->{'multiplier'} ?
                                $param->{'multiplier'} : 3;

    if( !defined $range->[0] &&
        !defined $range->[1] ) {
        return -1;
    }

    if( $type eq 'numb' ) {
        return is_in_range_numeric(
                    $value,
                    {
                        'range' => $range,
                        'sigma' => $param->{'sigma'},
                        'multiplier' => $su_multiplier,
                    }
                );
    } else {
        return is_in_range_char( $value, $param );
    }
}

##
# Checks numeric value against an inclusive numeric range.
#
# @param $value
#       Value to be checked.
# @param $param
#       Parameter hash with the following keys:
#       {
#         # Reference to a range array as returned by the
#         # COD::CIF::DDL::Ranges::parse_range() subroutine
#           'range' => [0, 10],
#         # Standard uncertainty (s.u.) to be used when determining
#         # if a numeric value resides in the specified range.
#         # See the 'multiplier' option for more details
#           'sigma'  => 0.1,
#         # Multiplier that should be applied to the standard
#         # uncertainty (s.u.) when determining if a numeric
#         # value resides in the specified range. For example,
#         # a multiplier of 3.5 means that the value is treated
#         # as valid if it falls in the interval of
#         # [lower bound - 3.5 * s.u.; upper bound + 3.5 * s.u.]
#           'multiplier' => 3,
#       }
# @return
#        0 if the value is out of the provided range or is not a number
#          at all;
#        1 if the value is in the provided range.
##
sub is_in_range_numeric
{
    my ( $value, $param ) = @_;

    my $min   = $param->{'range'}[0];
    my $max   = $param->{'range'}[1];
    my $sigma = $param->{'sigma'};
    my $multiplier = $param->{'multiplier'};

    if( !looks_like_number($value) || $value =~ m/^[+-]?(inf|nan)/i ) {
        return 0;
    }

    if( defined $sigma && defined $multiplier ) {
        $min = $min - $multiplier * $sigma if defined $min;
        $max = $max + $multiplier * $sigma if defined $max;
    };

    if(
        ( !defined $max || $value <= $max )
        &&
        ( !defined $min || $value >= $min )
    ) {
        return 1;
    }
    return 0;
}

##
# Checks character value against an inclusive character range.
# @param $value
#       Value to be checked.
# @param $param
#       Parameter hash with the following keys:
#       {
#         # Reference to a range array as returned by the
#         # COD::CIF::DDL::Ranges::parse_range() subroutine.
#           'range' => ['a', 'c'],
#       }
# @return
#        0 if the value is out of the provided range,
#        1 if the value is in the provided range.
##
sub is_in_range_char
{
    my ( $value, $param ) = @_;

    my $range = $param->{'range'};

    if(
        ( !defined $range->[0] || $value ge $range->[0] )
        &&
        ( !defined $range->[1] || $value le $range->[1] )
    ) {
        return 1;
    }
    return 0;
}

1;
