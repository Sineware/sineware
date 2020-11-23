SINEWARE_DEVELOPMENT ?= false
BUILD_CONTAINER ?= true

all: clean build-container adelie_rootfs system_rootfs sineware_img
	@echo "Sineware Build Complete!"
	@date

# make folders if they are not already there
# clean out existing folders.
clean:
	mkdir -p build-scripts/output
	mkdir -p artifacts
	mkdir -p iso-build-scripts/output/*
	rm -rf artifacts/*
	rm -rf build-scripts/output/*
	rm -rf iso-build-scripts/output/*

build-container:
ifeq ($(BUILD_CONTAINER),true)
	@echo "Building the Docker build container"
	docker build . -t sineware-build
else
	@echo "Skipping building the Docker build container."
endif

adelie_rootfs:
	@echo "Building the Adelie RootFS!"
#ifeq ($(SINEWARE_DEVELOPMENT),true)
#	@echo "Running the container interactivly (SINEWARE_DEVELOPMENT=true)"
#	docker run -i -t -v "$(CURDIR)"/build-scripts:/build-scripts --rm --env SINEWARE_DEVELOPMENT=true sineware-build
#	mv build-scripts/output/sineware.tar.gz artifacts/
#else
#	docker run -i -v "$(CURDIR)"/build-scripts:/build-scripts --rm sineware-build
#	mv build-scripts/output/sineware.tar.gz artifacts/
#endif

system_rootfs:
ifeq ($(SINEWARE_DEVELOPMENT),true)
	@echo "Running the container interactivly (SINEWARE_DEVELOPMENT=true)"
	docker run -i -t -v "$(CURDIR)"/build-scripts:/build-scripts --rm --env SINEWARE_DEVELOPMENT=true sineware-build
	mv build-scripts/output/sineware.tar.gz artifacts/
else
	docker run -i -v "$(CURDIR)"/build-scripts:/build-scripts --rm sineware-build
	mv build-scripts/output/sineware.tar.gz artifacts/
endif

sineware_img:
	cp artifacts/sineware.tar.gz iso-build-scripts/files/
	docker run -i -v "$(CURDIR)"/iso-build-scripts:/build-scripts --rm \
	-v /dev:/dev \
	--privileged \
	sineware-build
	mv iso-build-scripts/output/sineware-hdd.img artifacts/
	rm iso-build-scripts/files/sineware.tar.gz
