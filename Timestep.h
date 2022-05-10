#ifndef MDA_TIMESTEP_H_
#define MDA_TIMESTEP_H_

#include "Dimensions.h"
#include <cstddef>
#include <cstdint>
#include <cstdio>

namespace mdacore {

template <typename T, class DimensionsT> class Timestep {

public:
  const std::uint64_t n_atoms;
  DimensionsT unitcell;

  T *positions = nullptr;
  T *velocities = nullptr;
  T *forces = nullptr;

  // Constructor
  Timestep(const std::uint64_t n_atoms, const typename DimensionsT::type *box)
      : n_atoms(n_atoms), frame(-1), has_positions(false),
        has_velocities(false), has_forces(false), unitcell(box) {}

  // Copy constructor
  //   Timestep(const Timestep &c) { natoms = c.natoms; }

  // Dump state to stdout
  void DebugPrint() {
    std::printf("natoms %lli\n", n_atoms);
    std::printf("has positions %s\n", has_positions ? "true" : "false");
    std::printf("has velocities %s\n", has_velocities ? "true" : "false");
    std::printf("has forces %s\n", has_forces ? "true" : "false");
    unitcell.DebugPrint();
  }

private:
  std::int64_t frame;
  bool has_positions;
  bool has_velocities;
  bool has_forces;
};

} // namespace mdacore

#endif // MDA_TIMESTEP_H_
