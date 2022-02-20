#! /bin/sh

WORK_DIR="$(pwd)"
SRC_DIR="$WORK_DIR"
DIST_DIR="$WORK_DIR/Releases"
BUILD_VOLUME_NAME="swift_linux_build"

# Help

if [ "$1" == "--help" ]; then
	echo "Compiles and bundles a Swift project for either Linux or macOS and produces";
	echo "an archive with binaries to a local \"Releases\" directory for distribution.";
	echo "This variant of the build script only compiles for Linux (x86).";
	echo "";
	echo "Usage:";
	echo "  build-release.sh <target> <version string>";
	echo ""
	echo "Examples:";
	echo "  build-release.sh My-Application-0.2.0";
	echo "  build-release.sh My-Application-1.12.0";
	exit 0;
fi

# Argument Validation

if [ "$1" == "" ]; then
	echo "Missing release version string."
	exit 1
fi

# Arguments

DIST_NAME="$1"

# Logic

compile_linux() {
	docker volume create "$BUILD_VOLUME_NAME"
	docker run -t \
		-v="$SRC_DIR:/host:cached" \
		-v="$SRC_DIR/ColorThemeUtility:/work/ColorThemeUtility:cached" \
		-v="$SRC_DIR/ColorThemeModelingFramework:/work/ColorThemeModelingFramework:cached" \
		-v="$SRC_DIR/ColorThemeCodingFramework:/work/ColorThemeCodingFramework:cached" \
		-v="$SRC_DIR/ColorThemeEnclosureFramework:/work/ColorThemeEnclosureFramework:cached" \
		-v="$SRC_DIR/Package.swift:/work/Package.swift:cached" \
		-v="$DIST_DIR:/releases:cached" \
		-v="$BUILD_VOLUME_NAME:/build" \
		-w="/work" \
		custom/swift bash -c "\
			swift build --build-path /build -c release && \
			cd /build/release && \
			tar czfv '/releases/$DIST_NAME.tar.gz' \$(find . -maxdepth 1 -type f ! -name '*.*') \
		"
}

# Execution 

compile_linux

#cp /host/Package.resolved /work/ && \
#			swift package resolve && \