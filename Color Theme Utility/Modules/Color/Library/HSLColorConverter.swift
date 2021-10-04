//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

protocol HSLColorConverter {
	
	typealias ColorValue = Color.ColorValue
	typealias RGBColorValueComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	typealias HSLColorValueComponents = (hue: ColorValue, saturation: ColorValue, lightness: ColorValue)
	
}

extension HSLColorConverter {
	
	static func hslComponents(for components: RGBColorValueComponents) -> HSLColorValueComponents {
		let (red, green, blue) = components
		let min = min(red, green, blue)
		let max = max(red, green, blue)
		
		guard min != max else {
			return (hue: 0, saturation: 0, lightness: max)
		}
		
		let delta = max - min
		let saturation = delta / max
		let hue = hueColorValue(components, max, delta)
		
		return (hue, saturation, max)
	}
	
	private static func hueColorValue(_ components: RGBColorValueComponents, _ max: ColorValue, _ delta: ColorValue) -> ColorValue {
		let value = hueComponent(components, max, delta) * 60
		
		guard value >= 0 else {
			return value + 360
		}
		
		return value / 360
	}
	
	private static func hueComponent(_ components: RGBColorValueComponents, _ max: ColorValue, _ delta: ColorValue) -> ColorValue {
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

extension HSLColorConverter {
	
	private static var hueOneHalf: ColorValue { 1/2 }
	private static var hueOneThird: ColorValue { 1/3 }
	private static var hueTwoThirds: ColorValue { 2/3 }
	private static var hueOneSixth: ColorValue { 1/6 }
	
	static func rgbComponents(for components: HSLColorValueComponents) -> RGBColorValueComponents {
		let (hue, saturation, lightness) = components
		
		guard saturation > 0 else {
			return (red: lightness, green: lightness, blue: lightness)
		}
		
		let (lightnessFactor, inverseLightnessFactor) = intermediateRGBLightnessFactors(lightness, saturation)
		let red = intermediateRGBColorValue(hueFactor: hue + hueOneThird, lightnessFactor: lightnessFactor, inverseLightnessFactor: inverseLightnessFactor)
		let green = intermediateRGBColorValue(hueFactor: hue, lightnessFactor: lightnessFactor, inverseLightnessFactor: inverseLightnessFactor)
		let blue = intermediateRGBColorValue(hueFactor: hue - hueOneThird, lightnessFactor: lightnessFactor, inverseLightnessFactor: inverseLightnessFactor)
		
		return (red, green, blue)
	}
	
	private static func intermediateRGBColorValue(hueFactor: ColorValue, lightnessFactor: ColorValue, inverseLightnessFactor: ColorValue) -> ColorValue {
		let hueFactor = normalizedRGBHueFactor(hueFactor)
		
		switch hueFactor {
		case ..<hueOneSixth:
			return lightnessFactor + (inverseLightnessFactor - lightnessFactor) * 6 * hueFactor
		case ..<hueOneHalf:
			return inverseLightnessFactor
		case ..<hueTwoThirds:
			return lightnessFactor + (inverseLightnessFactor - lightnessFactor) * (hueTwoThirds - hueFactor) * 6
		default:
			return lightnessFactor
		}
	}
	
	private static func normalizedRGBHueFactor(_ hueFactor: ColorValue) -> ColorValue {
		if hueFactor < 0 {
			return hueFactor + 1
		}
		
		if hueFactor > 1 {
			return hueFactor - 1
		}
		
		return hueFactor
	}
	
	private static func intermediateRGBLightnessFactors(_ lightness: ColorValue, _ saturation: ColorValue) -> (base: ColorValue, inverted: ColorValue) {
		let lightnessFactor: ColorValue = {
			if lightness < 0.5 {
				return lightness * (1 + saturation)
			} else {
				return lightness + saturation - lightness * saturation
			}
		}()
		
		let invertedLightnessFactor: ColorValue = lightness * 2 - lightnessFactor
		
		return (lightnessFactor, invertedLightnessFactor)
	}
	
}
