
#include "Dimensions.h"
#include "Timestep.h"

int main() {

  float f_boxmat[6] = {0, 1, 2, 3, 4, 5};
  double d_boxmat[6] = {0, 1, 2, 3, 4, 5};

  float f_boxmat_tric[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
  double d_boxmat_tric[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};

  auto tstep_ortho_f =
      mdacore::Timestep<float, mdacore::OrthogonalDimensions<float>>(10,
                                                                     f_boxmat);
  tstep_ortho_f.DebugPrint();

  auto tstep_ortho_d =
      mdacore::Timestep<float, mdacore::OrthogonalDimensions<double>>(10,
                                                                      d_boxmat);
  tstep_ortho_d.DebugPrint();

  auto tstep_tric_f =
      mdacore::Timestep<float, mdacore::TriclinicDimensions<float>>(10,
                                                                     f_boxmat_tric);
tstep_tric_f.DebugPrint();

  auto tstep_tric_d =
      mdacore::Timestep<float, mdacore::TriclinicDimensions<double>>(10,
                                                                      d_boxmat_tric);
tstep_tric_d.DebugPrint();
}