//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 19/01/2022.
//

// MARK: Library

typealias CallResults<Value> = (value: Value?, error: AssemblyError?)
typealias EncodedCallResults = (value: String?, error: String?)

// MARK: Presets

var missingResultsError: AssemblyError {
	return AssemblyError(kind: .missingResults, description: "Expected results or error but found neither.")
}

// MARK: Calling

func call<ReturnType>(_ block: () throws -> ReturnType) -> CallResults<ReturnType> {
	do {
		let value = try block()
		return (value, nil)
	} catch let error as AssemblyError {
		return (nil, error)
	} catch {
		let wrappedError = AssemblyError(kind: .deferred, description: error.localizedDescription)
		return (nil, wrappedError)
	}
}

// MARK: Encoding

func encode<Value: Encodable>(_ results: CallResults<Value>) -> EncodedCallResults {
	if let error = results.error {
		return (nil, encode(error))
	}
	
	if let value = results.value {
		return (encode(value), nil)
	}
	
	return (nil, nil)
}

func unwrapAndEncode<Value: Encodable>(_ results: CallResults<Value>) -> String {
	if let error = results.error {
		return encode(error)
	}
	
	if let value = results.value {
		return encode(value)
	}
	
	return encode(missingResultsError)
}

func encode<Value: Encodable>(_ value: Value) -> String {
	let encoder = JSONEncoder()
	encoder.outputFormatting = [.sortedKeys]
	let data = try! encoder.encode(value)
	
	return String(data: data, encoding: .utf8)!
}
