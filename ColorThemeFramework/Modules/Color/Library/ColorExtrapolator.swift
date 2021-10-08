//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 07/10/2021.
//

import Foundation

public protocol ColorExtrapolator {
	
	typealias ColorValue = Color.ColorValue
	typealias HSLColorComponents = (hue: ColorValue, saturation: ColorValue, lightness: ColorValue)
	
}

extension ColorExtrapolator {
	
	/// Generates and returns a sequence of colors distributed in tone to
	/// produce a palette of the given length. The created sequence always
	/// contains the provided *base color* as its first element.
	public static func extrapolatedColorSequence(from color: Color, numberOfColors: Int, skewing colorTransform: ColorTransform) -> [Color] {
		let (baseHue, baseSaturation, baseLightness) = color.hsl
		let stride = paletteStride(numberOfColors: numberOfColors, skewing: colorTransform)
		
		var colors: [Color] = []
		
		for iteration in 0 ..< numberOfColors {
			let multiplier = ColorValue(iteration)
			let hue = baseHue + stride.hue * multiplier
			let saturation = baseSaturation + stride.saturation * multiplier
			let lightness = baseLightness + stride.lightness * multiplier
			let paletteColor = Color(hue: hue, saturation: saturation, lightness: lightness)
			
			colors.append(paletteColor)
		}
		
		return colors
	}
	
	/// Returns a uniform stride of change applied to a color's HSL components
	/// to produce a sequential palette.
	private static func paletteStride(numberOfColors: Int, skewing colorTransform: ColorTransform) -> HSLColorComponents {
		let maxDelta = paletteStrideDelta(skewing: colorTransform)
		let count = ColorValue(numberOfColors)
		
		return (maxDelta.hue / count, maxDelta.saturation / count, maxDelta.lightness / count)
	}
	
	private static func paletteStrideDelta(skewing colorChange: ColorTransform) -> (HSLColorComponents) {
		let (hue, saturation, lightness) = (0.1, 0.25, 0.25) as HSLColorComponents
		
		switch colorChange {
		case .lighter:
			return (hue, saturation, lightness)
		case .darker:
			return (-hue, -saturation, -lightness)
		}
	}
	
}

// MARK: Library

public enum ColorTransform {
	case lighter
	case darker
}
