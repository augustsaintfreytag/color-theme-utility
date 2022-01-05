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
	
	public static var paletteOffsetsZero: HSLColorComponents { (0, 0, 0) }
	public static var paletteOffsetsLight: HSLColorComponents { (0, -0.15, 0.15) }
	public static var paletteOffsetsDark: HSLColorComponents { (0, 0.15, -0.25) }
	
	// MARK: Single Color
	
	public static func transformedColor(from baseColor: Color, skewing colorTransform: ColorTransform, modifier: ColorValue = 1.0) -> Color {
		let stride = paletteStride(numberOfColors: 2, skewing: colorTransform)
		let transform: HSLColorComponents = (stride.hue * modifier, stride.saturation * modifier, stride.lightness * modifier)
		
		return transformedColor(from: baseColor, applying: transform)
	}
	
	public static func transformedColor(from baseColor: Color, applying transform: HSLColorComponents) -> Color {
		let (baseHue, baseSaturation, baseLightness) = baseColor.hsl
		
		let hue = limit(baseHue + transform.hue)
		let saturation = limit(baseSaturation + transform.saturation)
		let lightness = limit(baseLightness + transform.lightness)
		
		return Color(hue: hue, saturation: saturation, lightness: lightness)
	}
	
	// MARK: Color Sequence
	
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
	
	// MARK: Utility
	
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
			return paletteOffsetsLight
		case .darker:
			return paletteOffsetsDark
		}
	}
	
}

// MARK: Library

public enum ColorTransform: String, CaseIterable {
	case lighter
	case darker
}
