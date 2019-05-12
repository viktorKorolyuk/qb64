#!/bin/bash
if [ "$TRAVIS_OS_NAME" = "osx" ]; then exec .travis/build-osx.sh; fi

###### Part 1: Build old QB64 ######
echo "Preparing bootstrap:"
find . -type f -iname "*.sh" -exec chmod +x {} \;
find . -type f -iname "*.a" -exec rm {} \;
find . -type f -iname "*.o" -exec rm {} \;

rm internal/temp/* 2> /dev/null

com_build() {
  cd internal/c/$1/os/lnx
  echo -n "Building $2..."
  ./setup_build.sh
  if [ $? -ne 0 ]; then
    echo "$2 build failed."
    exit 1
  fi
  echo "Done"
  cd - > /dev/null
} 

com_build "libqb" "libQB"
com_build "parts/video/font/ttf" "FreeType"
com_build "parts/core" "FreeGLUT"

cp -r internal/source/* internal/temp/
cd internal/c
echo -n "Bootstrapping QB64..."
g++ $NOPIE -w qbx.cpp libqb/os/lnx/libqb_setup.o parts/video/font/ttf/os/lnx/src.o parts/core/os/lnx/src.a -lGL -lGLU -lX11 -lcurses -lpthread -ldl -lrt -D FREEGLUT_STATIC -DDEPENDENCY_USER_MODS -o ../../qb64_bootstrap
if [ $? -ne 0 ]; then
  echo "QB64 bootstrap failed"
  exit 1
fi
echo "Done"
cd - > /dev/null

###### Part 2: Build new QB64 from .bas sources ######
echo -n "Translating .bas source..."
echo From git `echo $TRAVIS_COMMIT | sed 's/\(.......\).*$/\1/'` > internal/version.txt
./qb64_bootstrap -x -z source/qb64.bas > /tmp/qb64-output
rm qb64_bootstrap
if [ `grep -v '^WARNING' /tmp/qb64-output | wc -l` -gt 2 ]; then
  cat /tmp/qb64-output
  rm /tmp/qb64-output
  exit 1
fi
echo "Done"

echo -n "Testing compile/link..."
# extract g++ line
cd internal/temp/
cpp_call=`awk '$1=="g++" {print $0}' < recompile_lnx.sh`
echo $cpp_call

# run g++
cd ../c/
${cpp_call/-no-pie/} -o ../../qb64_testrun
if [ $? -ne 0 -o ! -f ../../qb64_testrun ]; then
  echo "Compile/link test failed"
  exit 1
fi
cd ../../
rm qb64_testrun
echo "Done"
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then exit; fi

###### Part 3: Establish new bootstrapee ######
rm internal/source/*
mv internal/temp/* internal/source/
find . -type f -iname "*.a" -exec rm {} \;
find . -type f -iname "*.o" -exec rm {} \;
cd internal/source
rm debug_* recompile_*
