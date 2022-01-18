//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 20/11/2021.
//

import Foundation
import ColorThemeModelingFramework

/// Functionality to color correct themes for display in terminals.
///
/// This protocol only supports applying color correction for *iTerm*.
/// Support for other terminal applications may be added in a future version.
public protocol TerminalThemeColorCorrector: HSLColorConverter {}

extension TerminalThemeColorCorrector {
	
	private static var itermForegroundColorCorrection: HSLColorComponents { (0, 0, 0.05) }
	private static var itermBackgroundColorCorrection: HSLColorComponents { (0, 0, 0.05) }

	/// Applies color correction for *iTerm* to all colors in the given theme.
	public static func colorCorrectedTheme(_ theme: IntermediateTheme, for terminal: TerminalApplication) -> IntermediateTheme {
		switch terminal {
		case .iterm:
			return colorCorrectedThemeForIterm(theme)
		default:
			return theme
		}
	}

	private static func colorCorrectedThemeForIterm(_ theme: IntermediateTheme) -> IntermediateTheme {
		return theme.transformed { keyPath, color in
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
