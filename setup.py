from setuptools import Extension, setup
from Cython.Build import cythonize
import numpy as np


def extensions():
    """ setup extensions for this module
    """
    exts = []
    exts.append(
        Extension(
            'mdacore',
            sources= ["./src/Dimensions.pyx"],
            include_dirs=[ "./src/", np.get_include()],
            language="c++",
            extra_compile_args=["-std=c++11"],
            extra_link_args=["-std=c++11"],
            define_macros=[('NPY_NO_DEPRECATED_API', 'NPY_1_7_API_VERSION')]
        ))
    return cythonize(exts, gdb_debug=False)


setup(
    ext_modules=extensions()
)
