# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Libtool"
version = v"2.4.2"

# Collection of sources required to build Libtool
sources = [
    "git://git.savannah.gnu.org/libtool.git" =>
    "91c99165d9cbdd14569f046eb586c67020dd1045",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libtool/
./bootstrap 
./configure --prefix=$prefix --host=$target
make
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libltdl", :libltdl)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/yukota/TexinfoBuilder/releases/download/6.5-0/build_texinfo.v6.5.0.jl",
    "https://github.com/yukota/help2manBuilder/releases/download/v1.47.8-0/build_help2man.v1.47.8.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

