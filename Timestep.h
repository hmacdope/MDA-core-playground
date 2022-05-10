#ifndef MDA_TIMESTEP_H_
#define MDA_TIMESTEP_H_

#include <cstdint>
#include <cstdio>

namespace mdacore {

template <typename T> class Timestep {

  const std::int64_t n_atoms;

public:
  // Default constructor
  explicit Timestep(const std::int64_t n_atoms) : n_atoms(n_atoms), has_positions(false) {}

  // Copy constructor
  //   Timestep(const Timestep &c) { natoms = c.natoms; }

  // Dump state
  void DebugPrint() {
      std::printf("natoms %lli\n", n_atoms);
      std::printf("has positions %s\n", has_positions?"true":"false");
  }

private:
  bool has_positions;
};

} // namespace mdacore

#endif // MDA_TIMESTEP_H_
