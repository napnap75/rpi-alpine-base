#!/bin/bash
set -e

for version in "v3.4"; do
    (
	cd "$version"

	REL=$version
	ARCH=armhf
	qemu_arch=arm

	MIRROR=http://dl-cdn.alpinelinux.org/alpine
	REPO=$MIRROR/$REL/main
	TMP=tmp
	ROOTFS=rootfs

	mkdir -p $TMP $ROOTFS/usr/bin

	# download apk.static
	if [ ! -f $TMP/sbin/apk.static ]; then
	    apkv=$(curl -sSL $REPO/$ARCH/APKINDEX.tar.gz | tar -Oxz | strings |
		grep '^P:apk-tools-static$' -A1 | tail -n1 | cut -d: -f2)
	    curl -sSL $REPO/$ARCH/apk-tools-static-${apkv}.apk | tar -xz -C $TMP sbin/apk.static
	fi

	# install qemu-user-static
	if [ -n "${qemu_arch}" ]; then
	    if [ ! -f x86_64_qemu-${qemu_arch}-static.tar.xz ]; then
		wget -N https://github.com/multiarch/qemu-user-static/releases/download/v2.5.0/x86_64_qemu-${qemu_arch}-static.tar.xz
	    fi
	    tar -xvf x86_64_qemu-${qemu_arch}-static.tar.xz -C $ROOTFS/usr/bin/
	fi

	# copy entry.sh
	cp ../entry.sh .

	# create rootfs
	sudo $TMP/sbin/apk.static --repository $REPO --update-cache --allow-untrusted \
	    --root $ROOTFS --initdb add alpine-base --verbose

	# create tarball of rootfs
	sudo tar --numeric-owner -C $ROOTFS -c . | xz > rootfs.tar.xz

	# clean up
	sudo rm -fr $ROOTFS $TMP
    )
done
