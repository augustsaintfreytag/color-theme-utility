//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 20/11/2021.
//

import Foundation

public protocol IntermediateThemeColorCorrector: HSLColorConverter {}

extension IntermediateThemeColorCorrector {
	
	private static var itermForegroundColorCorrection: HSLColorComponents { (0, 0, 0.05) }
	private static var itermBackgroundColorCorrection: HSLColorComponents { (0, 0, 0.05) }
	
	public static func colorCorrectedThemeForTerminal(_ theme: IntermediateTheme) -> IntermediateTheme {
		theme.transformed { keyPath, color in
			var (hue, saturation, lightness) = color.hsl

			switch keyPath {
			case \.background:
				hue += itermBackgroundColorCorrection.hue
				saturation += itermBackgroundColorCorrection.saturation
				lightness += itermBackgroundColorCorrection.lightness
			default:
				hue += itermForegroundColorCorrection.hue
				saturation += itermForegroundColorCorrection.saturation
				lightness += itermForegroundColorCorrection.lightness
			}

			return Color(hue: hue, saturation: saturation, lightness: lightness)
		}
	}
	
}
