//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

protocol HSLColorConverter {
	
	typealias ColorValue = Color.ColorValue
	typealias ColorValueComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	typealias HSLColorValueComponents = (hue: ColorValue, saturation: ColorValue, lightness: ColorValue)
	
}

extension HSLColorConverter {
	
	static func hslComponents(for components: ColorValueComponents) -> HSLColorValueComponents {
		let (red, green, blue) = components
		let min = min(red, green, blue)
		let max = max(red, green, blue)
		
		guard min != max else {
			return (hue: 0, saturation: 0, lightness: max)
		}
		
		let delta = max - min
		let saturation = delta / max
		let hue = hue(components, max, delta)
		
		return (hue, saturation, max)
	}
	
	private static func hue(_ components: ColorValueComponents, _ max: ColorValue, _ delta: ColorValue) -> ColorValue {
		let value = hueComponent(components, max, delta) * 60
		
		guard value >= 0 else {
			return value + 360
		}
		
		return value
	}
	
	private static func hueComponent(_ components: ColorValueComponents, _ max: ColorValue, _ delta: ColorValue) -> ColorValue {
		let (red, green, blue) = components
		
		switch max {
		case red:
			return (green - blue) / delta
		case green:
			return 2 + (blue - red) / delta
		case blue:
			return 4 + (red - green) / delta
		default:
			return 0
		}
	}
	
}
