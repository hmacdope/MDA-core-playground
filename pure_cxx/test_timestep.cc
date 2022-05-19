
#include "../src/Dimensions.h"
#include "../src/Timestep.h"
#include <numeric>

int main() {

  std::vector<float> f_boxmat = {0.0, 1.0, 2.0, 3.0, 4.0, 5.0};
  // std::vector<double> d_boxmat = {0.0, 1.0, 2.0, 3.0, 4.0, 5.0};

  // std::vector<float> f_boxmat_tric = {0.0, 1.0, 2.0, 3.0, 4.0,
  //                                     5.0, 6.0, 7.0, 8.0};
  // std::vector<double> d_boxmat_tric = {0.0, 1.0, 2.0, 3.0, 4.0,
  //                                      5.0, 6.0, 7.0, 8.0};
  std::vector<float> position_dependent(30) ;
  std::iota(position_dependent.begin(), position_dependent.end(), 0);
  
  auto tstep_ortho_f = mdacore::Timestep<float, float>(10);
  tstep_ortho_f.DebugPrint();

  tstep_ortho_f.SetDimensions(f_boxmat);
  tstep_ortho_f.SetPositions(position_dependent);
  tstep_ortho_f.SetVelocities(position_dependent);
  tstep_ortho_f.SetForces(position_dependent);
  tstep_ortho_f.DebugPrint();

  tstep_ortho_f.SetDimensions(f_boxmat);
  tstep_ortho_f.SetDimensions(f_boxmat);
  tstep_ortho_f.SetPositions(position_dependent);
  tstep_ortho_f.DebugPrint();



}