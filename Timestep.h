#ifndef MDA_TIMESTEP_H_
#define MDA_TIMESTEP_H_

#include "Dimensions.h"
#include <cstdint>
#include <cstdio>

namespace mdacore {

template <typename T, class DimensionsT> class Timestep {

  const std::int64_t n_atoms;

public:
  // Default constructor
  explicit Timestep(const std::int64_t n_atoms, const T *box)
      : n_atoms(n_atoms), frame(-1), has_positions(false),
        has_velocities(false), has_forces(false) {
    auto unitcell = DimensionsT(box);
  }

  // Copy constructor
  //   Timestep(const Timestep &c) { natoms = c.natoms; }

  // Dump state
  void DebugPrint() {
    std::printf("natoms %lli\n", n_atoms);
    std::printf("has positions %s\n", has_positions ? "true" : "false");
    
  }

private:
  std::int64_t frame;
  bool has_positions;
  bool has_velocities;
  bool has_forces;

  DimensionsT unitcell();

  T *positions = nullptr;
  T *velocities = nullptr;
  T *forces = nullptr;
};

} // namespace mdacore

#endif // MDA_TIMESTEP_H_
