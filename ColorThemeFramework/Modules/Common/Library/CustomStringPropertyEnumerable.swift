//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

/// Enables a type to enumerate its own direct descendent properties, trying to cast
/// each as a custom string convertible type and returning a sequence of enumerated
/// properties with the property label and value description.
public protocol CustomStringPropertyEnumerable {}

extension CustomStringPropertyEnumerable {
	
	public func enumerated() -> [(property: String, value: String)] {
		let mirror = Mirror(reflecting: self)
		
		return mirror.children.reduce(into: [(property: String, value: String)]()) { collection, element in
			let (label, value) = element
			
			guard
				let propertyDescription = label,
				let valueDescription = (value as? CustomStringConvertible)?.description
			else {
				return
			}
			
			collection.append((propertyDescription, valueDescription))
		}
	}
	
}
