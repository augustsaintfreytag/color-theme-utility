#! /usr/bin/env zsh

TARGET_NAME="ColorThemeAssembly"
EXPORTED_FUNCTIONS=(
	allocateMemoryForUInt8
	deallocateMemoryForUInt8
	allocateMemoryForUInt32
	deallocateMemoryForUInt32
	allocateMemoryForString
	deallocateMemoryForString
	echoMessage 
	generateRandomColor 
	describeColor 
	convertColor 
	generateTheme
)

WASM_TOOLCHAIN="/Library/Developer/Toolchains/swift-wasm-latest.xctoolchain/usr/bin"

# Mode

BUILD_MODE=$1

if [[ "$BUILD_MODE" == "" ]]
then
	BUILD_MODE="debug"
fi

# Arguments

LINKER_ARGS=

for FUNCTION_NAME in "${EXPORTED_FUNCTIONS[@]}"
do
	LINKER_ARGS+="-Xlinker -export=$FUNCTION_NAME "
done

# Execution

echo "Building WASM target '$TARGET_NAME' for '$BUILD_MODE'…"

eval "$WASM_TOOLCHAIN/swift build -c $BUILD_MODE --triple wasm32-unknown-wasi -Xlinker -licuuc -Xlinker -licui18n $LINKER_ARGS"

if [[ "$BUILD_MODE" == "release" ]]
then
	echo "Optimizing binary for WASM target '$TARGET_NAME'…"
	eval "./optimize-wasm.sh ./.build/release/$TARGET_NAME.wasm"
fi
