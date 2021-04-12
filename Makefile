SINEWARE_DEVELOPMENT ?= false
BUILD_CONTAINER ?= true

all: clean deps setup_build build_container build_buildroot system_rootfs kernel initramfs sineware_img
	@echo "Sineware Build Complete!"
	@date
# Todo: save sineware-buildroot.tar.gz before running clean
all_no_buildroot: clean deps setup_build build_container system_rootfs kernel initramfs sineware_img
	@echo "Sineware Build Complete!"
	@date

# make folders if they are not already there
# clean out existing folders.
clean:
	mkdir -p artifacts
	mkdir -p buildmeta
	rm -rf artifacts/*

deps:
	@echo "Installing dependencies..."
	cd ./tools/setup-build; npm i
	cd ./tools/update-deployer; npm i

setup_build:
	@echo "Running the build setup script..."
	node ./tools/setup-build/index.js

build_container:
ifeq ($(BUILD_CONTAINER),true)
	@echo "Building the Docker build container"
	docker build . -t sineware-build
else
	@echo "Skipping building the Docker build container."
endif

build_buildroot:
	@echo "Starting Buildroot..."
	cd buildroot && ./build.sh

system_rootfs:
	test -s ./buildmeta/buildconfig.sh || { echo "Error: The buildmeta/buildconfig.sh file does not exist! Did the setup-build script run?"; exit 1; }
	test -s ./buildmeta/buildconfig.sh || { echo "Error: The artifacts/sineware-buildroot.tar.gz file does not exist! Did make build_buildroot run?"; exit 1; }
ifeq ($(SINEWARE_DEVELOPMENT),true)
	@echo "Running the container interactivly (SINEWARE_DEVELOPMENT=true)"
	docker run -i -t -v "$(CURDIR)"/build-scripts:/build-scripts -v "$(CURDIR)"/artifacts:/artifacts \
	-v "$(CURDIR)"/buildmeta:/buildmeta \
	-v /dev:/dev --privileged --rm --env SINEWARE_DEVELOPMENT=true sineware-build
else
	docker run -i -v "$(CURDIR)"/build-scripts:/build-scripts -v "$(CURDIR)"/artifacts:/artifacts \
	-v "$(CURDIR)"/buildmeta:/buildmeta \
	-v /dev:/dev --privileged --rm sineware-build
endif

sineware_img:
	docker run -i -t -v "$(CURDIR)"/iso-build-scripts:/build-scripts --rm \
	-v "$(CURDIR)"/artifacts:/artifacts \
	-v "$(CURDIR)"/buildmeta:/buildmeta \
	-v /dev:/dev \
	--privileged \
	sineware-build

initramfs:
	docker run -i -t \
	-v "$(CURDIR)"/initramfs-gen:/build-scripts \
	-v "$(CURDIR)"/artifacts:/artifacts \
	-v "$(CURDIR)"/buildmeta:/buildmeta \
	-v /dev:/dev --privileged --rm --env SINEWARE_DEVELOPMENT=true sineware-build

kernel:
	docker run -i -t \
	-v "$(CURDIR)"/kernel-gen:/build-scripts \
	-v "$(CURDIR)"/artifacts:/artifacts \
	-v "$(CURDIR)"/buildmeta:/buildmeta \
	-v /dev:/dev --privileged --rm --env SINEWARE_DEVELOPMENT=true sineware-build


sineware_container:
	cp ./artifacts/sineware.tar.gz ./os-variants/container/
	cd ./os-variants/container; docker build . -t sineware
	rm -rf ./os-variants/container/sineware.tar.gz

deploy_update:
	@echo "Running the update deployer script..."
	source ./buildmeta/buildconfig.sh && node ./tools/update-deployer/index.js