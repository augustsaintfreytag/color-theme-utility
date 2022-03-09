//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 15/01/2022.
//

private let nullCharacter: CChar = "\0".cString(using: .utf8)!.first!

@_cdecl("allocateMemoryForUInt8")
func allocateMemoryForUInt8() -> UnsafeMutablePointer<UInt8> {
	return UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
}

@_cdecl("deallocateMemoryForUInt8")
func deallocateMemoryForUInt8(_ pointer: UnsafeMutablePointer<UInt8>) {
	pointer.deallocate()
}

@_cdecl("allocateMemoryForUInt32")
func allocateMemoryForUInt32() -> UnsafeMutablePointer<UInt32> {
	return UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
}

@_cdecl("deallocateMemoryForUInt32")
func deallocateMemoryForUInt32(_ pointer: UnsafeMutablePointer<UInt32>) {
	pointer.deallocate()
}

@_cdecl("allocateMemoryForString")
func allocateMemoryForString(_ size: Int) -> UnsafeMutablePointer<CChar> {
	let pointer = UnsafeMutablePointer<CChar>.allocate(capacity: size)
	pointer.initialize(repeating: nullCharacter, count: size)
	
	return pointer
}

@_cdecl("deallocateMemoryForString")
func deallocateMemoryForString(_ pointer: UnsafeMutablePointer<CChar>) {
	pointer.deallocate()
}
