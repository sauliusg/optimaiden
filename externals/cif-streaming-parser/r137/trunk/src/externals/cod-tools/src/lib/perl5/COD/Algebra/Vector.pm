#--*-perl-*-------------------------------------------------------------
#$Author: antanas $
#$Date: 2019-11-15 18:13:46 +0200 (Fri, 15 Nov 2019) $
#$Revision: 7412 $
#$URL: svn://cod.ibt.lt/cif-tools/trunk/src/lib/perl5/COD/Algebra/Vector.pm $
#-----------------------------------------------------------------------
#*
# Basic symmetry operator algebra (addition, multiplication, etc.).
#**

package COD::Algebra::Vector;

use strict;
use warnings;
use POSIX qw( floor );

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw(
    vdot
    vector_angle
    vector_len
    vector_sub
    vector_add
    vector_modulo_1
    vector_is_zero
    vectors_are_equal
    round_vector
    distance
    matrix_vector_mul
    modulo_1
    vector_matrix_mul
);

my $Pi = 4 * atan2(1, 1);

sub vdot($$)
{
    my ($v1, $v2) = @_;
    my $r = 0;

    for( my $i = 0; $i <= $#$v1; $i++ ) {
        $r += $v1->[$i] * $v2->[$i]
    }

    return $r;
}

sub vector_angle($$)
{
    my ($v1, $v2) = @_;
    use Math::Trig;
    my $cosine = vdot( $v1, $v2 ) / ( vector_len($v1) * vector_len($v2) );
    return 180 * Math::Trig::acos( $cosine ) / $Pi;
}

sub vector_len($)
{
    my ($v1) = @_;

    my $sqsum = 0;
    foreach (@$v1) {
        $sqsum += $_**2;
    }

    return sqrt($sqsum);
}

sub vector_sub($$)
{
    my ($v1, $v2) = @_;

    my @result;

    for( my $i = 0; $i < @$v1; $i++ ) {
        $result[$i] = $v1->[$i] - $v2->[$i]
    }

    return \@result;
}

sub vector_add($$)
{
    my ($v1, $v2) = @_;

    my @result;

    for( my $i = 0; $i < @$v1; $i++ ) {
        $result[$i] = $v1->[$i] + $v2->[$i]
    }

    return \@result;
}

sub modulo_1
{
    my $x = $_[0];
    return $x - POSIX::floor($x);
}

sub vector_modulo_1($)
{
    my ($v) = @_;

    my @r = map { modulo_1($_) } @$v;

    return \@r;
}

sub vector_is_zero($@)
{
    my ($vector, $eps) = @_;

    $eps = 1E-6 unless defined $eps;

    for (@$vector) {
        return 0 if abs($_) >= $eps;
    }
    return 1;
}

sub round_vector($@)
{
    my ($vector, $eps) = @_;

    $eps = 1E-10 unless defined $eps;

    map { $_ = POSIX::floor($_/$eps + 0.5)*$eps } @$vector;

    return $vector;
}

sub vectors_are_equal($$@)
{
    my ($v1, $v2, $eps) = @_;

    $eps = 1E-6 unless defined $eps;

    for( my $i = 0; $i < @$v1; $i++ ) {
        #print "delta = ", abs($v1->[$i] - $v2->[$i]), "\n";
        return 0 unless abs($v1->[$i] - $v2->[$i]) < $eps;
    }

    return 1;
}

sub distance($$)
{
    my ($v1, $v2) = @_;

    my $diff = vector_sub( $v1, $v2 );

    return vector_len($diff);
}

sub matrix_vector_mul($$)
{
    my($matrix, $vector) = @_;

    my @new_coordinates;

    for(my $i = 0; $i < @{$vector}; $i++)
    {
        $new_coordinates[$i] = 0;
        for(my $j = 0; $j < @{$vector}; $j++)
        {
            $new_coordinates[$i] += ${$matrix}[$i][$j] * ${$vector}[$j];
        }
    }

    return wantarray ? @new_coordinates : \@new_coordinates;
}

sub vector_matrix_mul($$)
{
    my($vector, $matrix) = @_;

    my @new_coordinates;

    for(my $i = 0; $i < @{$vector}; $i++)
    {
        $new_coordinates[$i] = 0;
        for(my $j = 0; $j < @{$vector}; $j++)
        {
            $new_coordinates[$i] += ${$vector}[$j] * ${$matrix}[$j][$i];
        }
    }

    return wantarray ? @new_coordinates : \@new_coordinates;
}

1;
