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
	
	private static var singleTransformModifier: ColorValue { 2.0 }
	private static var singleDesaturationTransformModifier: ColorValue { 0.5 }
	
	public static func transformedColor(from baseColor: Color, skewing colorTransform: ColorTransform) -> Color {
		let (baseHue, baseSaturation, baseLightness) = baseColor.hsl
		let stride = paletteStride(numberOfColors: 2, skewing: colorTransform)
		
		let hue = limit(baseHue + stride.hue * singleTransformModifier)
		let saturation = limit(baseSaturation + stride.saturation * singleTransformModifier)
		let lightness = limit(baseLightness + stride.lightness * singleTransformModifier)
		
		return Color(hue: hue, saturation: saturation, lightness: lightness)
	}
	
	/// Generates and returns a sequence of colors distributed in tone to
	/// produce a palette of the given length. The created sequence always
	/// contains the provided *base color* as its first element.
	public static func cascadingColorSequence(from baseColor: Color, numberOfColors: Int, skewing colorTransform: ColorTransform) -> [Color] {
		let (baseHue, baseSaturation, baseLightness) = baseColor.hsl
		let stride = paletteStride(numberOfColors: numberOfColors, skewing: colorTransform)
		
		var colors: [Color] = []
		
		for iteration in 0 ..< numberOfColors {
			let multiplier = ColorValue(iteration)
			let hue = limit(baseHue + stride.hue * multiplier)
			let saturation = limit(baseSaturation + stride.saturation * multiplier)
			let lightness = limit(baseLightness + stride.lightness * multiplier)
			let newColor = Color(hue: hue, saturation: saturation, lightness: lightness)
			
			colors.append(newColor)
		}
		
		return colors
	}
	
	private static func limit(_ value: ColorValue) -> ColorValue {
		return max(min(value, 1.0), 0.0)
	}
	
	/// Returns a uniform stride of change applied to a color's HSL components
	/// to produce a sequential palette.
	private static func paletteStride(numberOfColors: Int, skewing colorTransform: ColorTransform) -> HSLColorComponents {
		let maxDelta = paletteStrideDelta(skewing: colorTransform)
		let count = ColorValue(numberOfColors)
		
		return (maxDelta.hue / count, maxDelta.saturation / count, maxDelta.lightness / count)
	}
	
	private static func paletteStrideDelta(skewing colorChange: ColorTransform) -> (HSLColorComponents) {
		switch colorChange {
		case .lighter:
			return (0.075, -0.3, 0.15)
		case .darker:
			return (0.1, 0.1, -0.25)
		}
	}
	
}

// MARK: Library

public enum ColorTransform: String {
	case lighter
	case darker
}
