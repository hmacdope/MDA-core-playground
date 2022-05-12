
#include "Dimensions.h"
#include "Timestep.h"
#include <numeric>

int main() {

  std::vector<float> f_boxmat = {0.0, 1.0, 2.0, 3.0, 4.0, 5.0};
  std::vector<double> d_boxmat = {0.0, 1.0, 2.0, 3.0, 4.0, 5.0};

  std::vector<float> f_boxmat_tric = {0.0, 1.0, 2.0, 3.0, 4.0,
                                      5.0, 6.0, 7.0, 8.0};
  std::vector<double> d_boxmat_tric = {0.0, 1.0, 2.0, 3.0, 4.0,
                                       5.0, 6.0, 7.0, 8.0};

  auto tstep_ortho_f =
      mdacore::Timestep<float, mdacore::OrthogonalDimensions<float>>(10,
                                                                     f_boxmat);
  tstep_ortho_f.DebugPrint();

  auto tstep_ortho_d =
      mdacore::Timestep<float, mdacore::OrthogonalDimensions<double>>(10,
                                                                      d_boxmat);
  tstep_ortho_d.DebugPrint();

  auto tstep_tric_f =
      mdacore::Timestep<float, mdacore::TriclinicDimensions<float>>(
          10, f_boxmat_tric);
  tstep_tric_f.DebugPrint();

  auto tstep_tric_d =
      mdacore::Timestep<float, mdacore::TriclinicDimensions<double>>(
          10, d_boxmat_tric);
  tstep_tric_d.DebugPrint();

  std::vector<float> data(3 * 10);

  std::iota(data.begin(), data.end(), 0);

  tstep_ortho_f.SetPositions(data);
  tstep_ortho_f.SetVelocities(data);
  tstep_ortho_f.SetForces(data);

  tstep_ortho_f.DebugPrint();
}