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

template <typename T, typename BoxT> class Timestep {

public:
  std::uint64_t n_atoms;
  Dimensions<BoxT> unitcell;

  std::vector<T> positions;
  std::vector<T> velocities;
  std::vector<T> forces;

  bool has_dimensions;
  bool has_positions;
  bool has_velocities;
  bool has_forces;

  // Constructor
  explicit Timestep(const std::uint64_t n_atoms)
      : n_atoms(n_atoms), unitcell(), has_dimensions(false),
        has_positions(false), has_velocities(false), has_forces(false), frame(-1) {}

  // copy constructor

  void SetDimensions(const std::vector<BoxT> &dimensions) {
    set_dimensions(dimensions);
    set_dimensions_flag(true);
  }

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
    std::printf("has dimensions %s\n", has_dimensions ? "true" : "false");
    std::printf("has positions %s\n", has_positions ? "true" : "false");
    std::printf("has velocities %s\n", has_velocities ? "true" : "false");
    std::printf("has forces %s\n", has_forces ? "true" : "false");
    if (has_dimensions){
      unitcell.DebugPrint();
    }
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


  void set_dimensions_flag(bool val) { has_dimensions = val; }

  void set_positions_flag(bool val) { has_positions = val; }

  void set_velocities_flag(bool val) { has_velocities = val; }

  void set_forces_flag(bool val) { has_forces = val; }

  void positions_reserve() { positions.reserve(3 * n_atoms); }

  void velocities_reserve() { velocities.reserve(3 * n_atoms); }

  void forces_reserve() { forces.reserve(3 * n_atoms); }

  void set_dimensions(const std::vector<BoxT> &source) {
    unitcell.SetBox(source);
  }

  // note full copy interface, can this take ownership of a smart pointer
  void set_positions(const std::vector<T> &source) {
    // should we specify the number of elements in this and below rather than
    //  relying on vector of correct size
    std::copy(source.begin(), source.end(), std::back_inserter(positions));
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
