#ifndef MDA_DIMENSIONS_H_
#define MDA_DIMENSIONS_H_

namespace mdacore {

template <typename T> class OrthogonalDimensions {
  T box[6];

public:
  OrthogonalDimensions(const T *src) {}
};

template <typename T> class TriclincDimensions {
  T box[9];

public:
  TriclincDimensions(const T *src) {}
};

template <typename T> class NoDimensions {
public:
  NoDimensions() {}
};

} // namespace mdacore

#endif // MDA_DIMENSIONS_H_