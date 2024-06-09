/*---------------------------------------------------------------------------*\
**$Author$
**$Date$ 
**$Revision$
**$URL$
\*---------------------------------------------------------------------------*/

#ifndef __SPGLIB_H
#define __SPGLIB_H

#include <EXTERN.h>
#include <perl.h>

SV* get_spacegroup( SV* cell_constant_ref, SV* atom_position_ref );

#endif
