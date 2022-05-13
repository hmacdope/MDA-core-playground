
#include "../src/Dimensions.h"
#include "../src/Timestep.h"
#include <numeric>

int main() {

  std::vector<float> f_boxmat = {0.0, 1.0, 2.0, 3.0, 4.0, 5.0};
  std::vector<double> d_boxmat = {0.0, 1.0, 2.0, 3.0, 4.0, 5.0};

  std::vector<float> f_boxmat_tric = {0.0, 1.0, 2.0, 3.0, 4.0,
                                      5.0, 6.0, 7.0, 8.0};
  std::vector<double> d_boxmat_tric = {0.0, 1.0, 2.0, 3.0, 4.0,
                                       5.0, 6.0, 7.0, 8.0};

  auto tstep_ortho_f = mdacore::Timestep<float, float>(10, f_boxmat);
  tstep_ortho_f.DebugPrint();

  auto tstep_ortho_d = mdacore::Timestep<double, double>(10, d_boxmat);
  tstep_ortho_d.DebugPrint();

  auto tstep_ortho_fd = mdacore::Timestep<float, double>(10, d_boxmat);
  tstep_ortho_fd.DebugPrint();


  auto tstep_tric_f = mdacore::Timestep<float, float>(10, f_boxmat_tric);
  tstep_tric_f.DebugPrint();

  auto tstep_tric_d = mdacore::Timestep<double, double>(10, d_boxmat_tric);
  tstep_tric_d.DebugPrint();

  auto tstep_tric_fd = mdacore::Timestep<double, double>(10, d_boxmat_tric);
  tstep_tric_fd.DebugPrint();
}