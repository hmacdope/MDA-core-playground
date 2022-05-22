#ifndef MDA_TIMESTEP_H_
#define MDA_TIMESTEP_H_

#include "Dimensions.h"
#include "Util.h"
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <string>
#include <vector>

namespace mdacore
{

  template <typename T, typename BoxT>
  class Timestep
  {

  public:
    std::uint64_t n_atoms;
    Dimensions<BoxT> unitcell;

    T *positions;
    T *velocities;
    T *forces;

    bool has_dimensions;
    bool has_positions;
    bool has_velocities;
    bool has_forces;

    // Constructor
    explicit Timestep(const std::uint64_t n_atoms)
        : n_atoms(n_atoms), unitcell(), has_dimensions(false),
          has_positions(false), has_velocities(false), has_forces(false), frame(-1) {}

    // copy constructor

    void SetDimensions(const std::vector<BoxT> &dimensions)
    {
      set_dimensions(dimensions);
      set_dimensions_flag(true);
    }

    void SetPositions(T *pos)
    {
      set_positions(pos);
      set_positions_flag(true);
    }

    void SetVelocities(T *vel)
    {
      set_velocities(vel);
      set_velocities_flag(true);
    }

    void SetForces(T *frc)
    {
      set_forces(frc);
      set_forces_flag(true);
    }

    // Dump state to stdout
    void DebugPrint()
    {
      std::printf("natoms %lli\n", n_atoms);
      std::printf("has dimensions %s\n", has_dimensions ? "true" : "false");
      std::printf("has positions %s\n", has_positions ? "true" : "false");
      std::printf("has velocities %s\n", has_velocities ? "true" : "false");
      std::printf("has forces %s\n", has_forces ? "true" : "false");
      if (has_dimensions)
      {
        unitcell.DebugPrint();
      }
      if (has_positions)
      {
        print_3col("positions", positions);
      }
      if (has_velocities)
      {
        print_3col("velocities", velocities);
      }
      if (has_forces)
      {
        print_3col("forces", forces);
      }
    }

  private:
    std::int64_t frame;

    void inline set_dimensions_flag(bool val) { has_dimensions = val; }

    void inline set_positions_flag(bool val) { has_positions = val; }

    void inline set_velocities_flag(bool val) { has_velocities = val; }

    void inline set_forces_flag(bool val) { has_forces = val; }

    void inline positions_reserve() { positions.reserve(3 * n_atoms); }

    void inline velocities_reserve() { velocities.reserve(3 * n_atoms); }

    void inline forces_reserve() { forces.reserve(3 * n_atoms); }

    void inline set_dimensions(const std::vector<BoxT> &source)
    {
      unitcell.SetBox(source);
    }

    // note full copy interface, can this take ownership of a smart pointer
    void inline set_positions(T *source)
    {
      positions = source;
    }

    // note full copy interface, can this take ownership of a smart pointer
    void inline set_velocities(T *source)
    {
      velocities = source;
    }

    // note full copy interface, can this take ownership of a smart pointer
    void inline set_forces(T *source)
    {
      forces = source;
    }
  };

} // namespace mdacore

#endif // MDA_TIMESTEP_H_
