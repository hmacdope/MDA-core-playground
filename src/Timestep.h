#ifndef MDA_TIMESTEP_H_
#define MDA_TIMESTEP_H_

#include "Dimensions.h"
#include "Util.h"
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <string>
#include <vector>

namespace mdacore {

template <typename T, class DimensionsT> class Timestep {

public:
  std::uint64_t n_atoms;
  DimensionsT unitcell;

  std::vector<T> positions;
  std::vector<T> velocities;
  std::vector<T> forces;

  //using Btype = typename DimensionsT::type;


  // null constructable
  Timestep() {}

  // Constructor
  Timestep(const std::uint64_t n_atoms,
           const std::vector<typename DimensionsT::type> &box)
      : n_atoms(n_atoms), unitcell(box), frame(-1), has_positions(false),
        has_velocities(false), has_forces(false) {}

  // copy constructor

  void SetPositions(const std::vector<T> &pos) {
    positions_reserve();
    set_positions(pos);
    set_positions_flag(true);
  }

  void SetVelocities(const std::vector<T> &vel) {
    velocities_reserve();
    set_velocities(vel);
    set_velocities_flag(true);
  }

  void SetForces(const std::vector<T> &frc) {
    forces_reserve();
    set_forces(frc);
    set_forces_flag(true);
  }

  // Dump state to stdout
  void DebugPrint() {
    std::printf("natoms %lli\n", n_atoms);
    std::printf("has positions %s\n", has_positions ? "true" : "false");
    std::printf("has velocities %s\n", has_velocities ? "true" : "false");
    std::printf("has forces %s\n", has_forces ? "true" : "false");
    unitcell.DebugPrint();
    if (has_positions) {
      print_3col("positions", positions);
    }
    if (has_velocities) {
      print_3col("velocities", velocities);
    }
    if (has_forces) {
      print_3col("forces", forces);
    }
  }

private:
  std::int64_t frame;
  bool has_positions;
  bool has_velocities;
  bool has_forces;

  void set_positions_flag(bool val) { has_positions = val; }

  void set_velocities_flag(bool val) { has_velocities = val; }

  void set_forces_flag(bool val) { has_forces = val; }

  void positions_reserve() { positions.reserve(3 * n_atoms); }

  void velocities_reserve() { velocities.reserve(3 * n_atoms); }

  void forces_reserve() { forces.reserve(3 * n_atoms); }

  // note full copy interface, can this take ownership of a smart pointer
  void set_positions(const std::vector<T> &source) {
    // should we specify the number of elements in this and below rather than
    //  relying on vector of correct size
    std::copy(source.begin(), source.begin(), std::back_inserter(positions));
  }

  // note full copy interface, can this take ownership of a smart pointer
  void set_velocities(const std::vector<T> &source) {
    std::copy(source.begin(), source.end(), std::back_inserter(velocities));
  }

  // note full copy interface, can this take ownership of a smart pointer
  void set_forces(const std::vector<T> &source) {
    std::copy(source.begin(), source.end(), std::back_inserter(forces));
  }
};

} // namespace mdacore

#endif // MDA_TIMESTEP_H_
