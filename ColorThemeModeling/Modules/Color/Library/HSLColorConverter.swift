//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

public protocol HSLColorConverter {
	
	typealias ColorValue = Color.ColorValue
	typealias RGBColorComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	typealias HSLColorComponents = (hue: ColorValue, saturation: ColorValue, lightness: ColorValue)
	
}

extension HSLColorConverter {
	
	public static func hslComponents(for components: RGBColorComponents) -> HSLColorComponents {
		let (red, green, blue) = components
		let chromaMin = min(red, green, blue)
		let chromaMax = max(red, green, blue)
		
		guard chromaMin != chromaMax else {
			return (hue: 0, saturation: 0, lightness: chromaMax)
		}
		
		let chromaDelta = chromaMax - chromaMin
		let lightness = (chromaMax + chromaMin) / 2
		let saturation = chromaDelta / (1 - abs(2 * lightness - 1))
		let hue = hueColorValue(components, chromaMax, chromaDelta)
		
		return (hue, saturation, lightness)
	}
	
	private static func hueColorValue(_ components: RGBColorComponents, _ max: ColorValue, _ delta: ColorValue) -> ColorValue {
		let value = rawHueColorValue(components, max, delta) * 60
		
		guard value >= 0 else {
			return (value + 360) / 360
		}
		
		return value / 360
	}
	
	private static func rawHueColorValue(_ components: RGBColorComponents, _ max: ColorValue, _ delta: ColorValue) -> ColorValue {
		let (red, green, blue) = components
		
		switch max {
		case red:
			return ((green - blue) / delta).truncatingRemainder(dividingBy: 6)
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
	
	public static func rgbComponents(from components: HSLColorComponents) -> RGBColorComponents {
		let hue = components.hue
		let saturation = components.saturation
		let lightness = components.lightness
		
		let chroma: ColorValue = (1 - abs(2 * lightness - 1)) * saturation
		let factor: ColorValue = chroma * (1 - abs((hue / (60 / 360)).truncatingRemainder(dividingBy: 2) - 1))
		let offset: ColorValue = max(0, lightness - chroma / 2)
		let componentFactors = rgbHueFactor(hue, chroma, factor)
		
		let (red, green, blue) = (
			componentFactors.red + offset,
			componentFactors.green + offset,
			componentFactors.blue + offset
		)
		
		return (red, green, blue)
	}
	
	private static func rgbHueFactor(_ hue: ColorValue, _ chroma: ColorValue, _ factor: ColorValue) -> RGBColorComponents {
		switch hue {
		case ..<(60 / 360): return (chroma, factor, 0)
		case ..<(120 / 360): return (factor, chroma, 0)
		case ..<(180 / 360): return (0, chroma, factor)
		case ..<(240 / 360): return (0, factor, chroma)
		case ..<(300 / 360): return (factor, 0, chroma)
		default: return (chroma, 0, factor)
		}
	}
	
}
