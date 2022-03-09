//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling

protocol ThemePropertyEnumerator: ColorPrinter, ColorModeler {}

extension ThemePropertyEnumerator {
	
	// MARK: Property Enumeration
	
	func enumeratedPropertyDescriptions(from enumeratedProperties: [(property: String, value: CustomStringConvertible)], childrenOf parentProperty: String? = nil) -> [[String]] {
		return enumeratedProperties.map { property, value in
			let property = { () -> String in
				guard let parentProperty = parentProperty else {
					return property
				}
				
				return "\(parentProperty).\(property)"
			}()
			
			let description = valueDescription(of: value)
			return [property, description.format, description.value]
		}
	}
	
	private func valueDescription(of value: CustomStringConvertible) -> (format: String, value: String) {
		let description = value.description
		
		if let color = value as? Color {
			let colorBlockDescription = Self.colorBlock.colored(with: color)
			return ("[Color]", "\(color.hexadecimalString) \(colorBlockDescription)")
		}
		
		if let color = Self.color(fromAutodetectedColorString: description) {
			let colorBlockDescription = Self.colorBlock.colored(with: color)
			return ("[Color]", "\(color.hexadecimalString) \(colorBlockDescription)")
		}
		
		return ("[Any]", description)
	}
	
	// MARK: Color Enumeration
	
	func enumeratedColors(in model: CustomPropertyEnumerable) -> [(property: String, color: Color)] {
		return enumeratedColors(from: model.enumerated())
	}
	
	func orderedEnumeratedColors(in model: CustomPropertyEnumerable) -> [(property: String, color: Color)] {
		return orderedEnumeratedColors(from: model.enumerated())
	}
	
	private func enumeratedColors(from enumeratedProperties: [(property: String, value: String)]) -> [(property: String, color: Color)] {
		return enumeratedProperties.reduce(into: [(property: String, color: Color)]()) { collection, element in
			let (property, value) = element
			
			guard let color = Self.color(fromAutodetectedColorString: value) else {
				return
			}
			
			collection.append((property, color))
		}
	}
	
	private func orderedEnumeratedColors(from enumeratedProperties: [(property: String, value: String)]) -> [(property: String, color: Color)] {
		return enumeratedColors(from: enumeratedProperties).sorted { lhs, rhs in
			lhs.color < rhs.color
		}
	}
	
}
