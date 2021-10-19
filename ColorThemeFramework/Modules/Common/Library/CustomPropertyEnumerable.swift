//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

/// Enables a type to enumerate its own direct descendent properties, trying to cast
/// each as a custom string convertible type and returning a sequence of enumerated
/// properties with the property label and value description.
public protocol CustomPropertyEnumerable {}

extension CustomPropertyEnumerable {
	
	public typealias EnumeratedValues<Value> = [(property: String, value: Value)]
	
	public func enumeratedDescriptions() -> EnumeratedValues<String> {
		var collection = EnumeratedValues<String>()
		
		forEachEnumeratedProperty { (label: String, value: CustomStringConvertible) in
			collection.append((label, value.description))
		}
		
		return collection
	}
	
	public func enumerated<Value>() -> EnumeratedValues<Value> {
		var collection = EnumeratedValues<Value>()
		
		forEachEnumeratedProperty { (label: String, value: Value) in
			collection.append((label, value))
		}
		
		return collection
	}
	
	public func enumeratedSortedByProperty<Value>() -> EnumeratedValues<Value> {
		return enumerated().sorted { lhs, rhs in
			return lhs.property < rhs.property
		}
	}
	
	public func enumeratedSortedByValue<Value: Comparable>() -> EnumeratedValues<Value> {
		return enumerated().sorted { lhs, rhs in
			return lhs.value < rhs.value
		}
	}
	
	private func forEachEnumeratedProperty<Value>(_ block: (_ label: String, _ element: Value) -> Void) {
		let mirror = Mirror(reflecting: self)
		
		return mirror.children.forEach { label, value in
			guard
				let label = label,
				let value = value as? Value
			else {
				return
			}
			
			block(label, value)
		}
	}
	
}
