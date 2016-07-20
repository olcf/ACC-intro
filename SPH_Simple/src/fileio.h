#ifndef fluid_fileio_h
#define fluid_fileio_h

#include "fluid.h"

void writeFile(fluid_particle *particles, param *params);
void writeBoundaryFile(boundary_particle *boundary, param *params);

#endif
