#!/bin/bash


# Clean
rm -Rf BUILD SOURCES SPECS RPMS BUILDROOT
mkdir -p BUILD SOURCES SPECS RPMS BUILDROOT

./boot.sh
./configure
make dist

VERSION=$(grep "Version:.*[0-9]" rhel/openvswitch.spec | tr -s " " |  awk '{print $2;}')
GITTAG=$(git log --format=%ct.%h -1)

# Copy required files
cp "openvswitch-${VERSION}.tar.gz" SOURCES
cp rhel/openvswitch.spec SPECS

rpmbuild --define "gittag ${GITTAG}" --define "_topdir $PWD" --without check -bb SPECS/openvswitch.spec

# Clean
rm -Rf "openvswitch-${VERSION}.tar.gz"

