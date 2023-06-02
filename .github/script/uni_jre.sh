#!/bin/bash
# This file is inspired by https://incenp.org/notes/2023/universal-java-app-on-macos.html
set -e

jre_aarch64="https://download.bell-sw.com/java/11.0.19+7/bellsoft-jre11.0.19+7-macos-aarch64.tar.gz"
jre_amd64="https://download.bell-sw.com/java/11.0.19+7/bellsoft-jre11.0.19+7-macos-amd64.tar.gz"

# Usage: die message ...
# From: https://mywiki.wooledge.org/BashFAQ/101
die() {
  printf '%s\n' "$*" >&2
  exit 1
}

wget $jre_aarch64
wget $jre_amd64

version=$(ls bellsoft-jre*-macos-amd64.tar.gz | sed -E "s,bellsoft-jre(.+)-macos-amd64.tar.gz,\1,")
[ -n "$version" ] || die "Cannot identify JRE version"

[ -f bellsoft-jre$version-macos-aarch64.tar.gz ] || die "Missing corresponding arm64 JRE"

echo "Extracting native JREs..."
rm -rf x86_64 arm64
mkdir x86_64 arm64
(cd x86_64
tar xf ../bellsoft-jre$version-macos-amd64.tar.gz)
(cd arm64
tar xf ../bellsoft-jre$version-macos-aarch64.tar.gz)

echo "Creating universal JRE..."
rm -rf universal
mkdir universal
find arm64 -type f | while read arm_file ; do
noarch_file=${arm_file#arm64/}
mkdir -p universal/${noarch_file%/*}
if file $arm_file | grep "Mach-O.\+arm64" ; then
	# Create universal binary from both x86_64 and arm64
	lipo -create -output universal/$noarch_file x86_64/$noarch_file $arm_file
	if file $arm_file | grep executable ; then
		chmod 755 universal/$noarch_file
	fi
else
	# Not a file with binary code, copy it as it is
	cp $arm_file universal/$noarch_file
fi
done

echo "Packaging the JRE..."
mv -f universal/jre* ./jre

echo "Clean up"
rm -rf x86_64 arm64 *tar* universal
