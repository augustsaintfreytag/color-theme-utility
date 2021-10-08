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
	
	public static func extrapolatedColorPalette(from color: Color, numberOfColors: Int) -> [Color] {
		let (baseHue, baseSaturation, baseLightness) = color.hsl
		let stride = paletteStride(numberOfColors: numberOfColors)
		
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
	private static func paletteStride(numberOfColors: Int) -> HSLColorComponents {
		let maxDelta: HSLColorComponents = (hue: 0.1, saturation: 0.25, lightness: 0.25)
		let count = ColorValue(numberOfColors)
		
		return (maxDelta.hue / count, maxDelta.saturation / count, maxDelta.lightness / count)
	}
	
}
