RESULT_DIR=./

NAME = appliance

EXTRAS = ./ramdisk/*
PACKETS = ./packets
ISO = ./system

RAMDISK_BUILD = ./.ramdisk_build
SYSTEMDISK_BUILD = ./.systemdisk_build

ISO_FILE = ${RESULT_DIR}/${NAME}.iso
RAMDISK_BIN = ${RESULT_DIR}/extra.gz

.PHONY: all iso systemdisk clean ramdisk

all: iso

${RAMDISK_BIN}:
	rm -rf ${RAMDISK_BUILD}
	mkdir -p ${RAMDISK_BUILD}
	cp -a ${EXTRAS} ${RAMDISK_BUILD}
	cd ${RAMDISK_BUILD}; find | sudo cpio -o -H newc | gzip -9 >../${RAMDISK_BIN}

systemdisk: ${RAMDISK_BIN}
	rm -rf ${SYSTEMDISK_BUILD}
	mkdir -p ${SYSTEMDISK_BUILD}
	mkdir -p ${SYSTEMDISK_BUILD}/cde
	cp -a ${ISO}/* ${SYSTEMDISK_BUILD}
	cp -a ${PACKETS}/* ${SYSTEMDISK_BUILD}/cde
	mv ${RAMDISK_BIN} ${SYSTEMDISK_BUILD}/boot/
	

iso: systemdisk
	mkisofs -l -J -V TSU-FINF-iso -no-emul-boot -boot-load-size 4 -boot-info-table -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o ${ISO_FILE} ${SYSTEMDISK_BUILD}

clean:
	rm -rf ${SYSTEMDISK_BUILD}
	rm -rf ${RAMDISK_BUILD}
