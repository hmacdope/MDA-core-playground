
#include "Timestep.h"
#include "Dimensions.h"

int main(){

float boxmat[6]  = {0,1,2,3,4,5};

auto tstep = mdacore::Timestep<float, mdacore::OrthogonalDimensions<float>>(10, boxmat);

tstep.DebugPrint();


}