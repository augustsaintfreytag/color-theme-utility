//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation

public protocol ThemeCoercionProvider: XcodeThemeModeler, IntermediateThemeModeler, TextMateThemeModeler, VisualStudioCodeThemeModeler {}

extension ThemeCoercionProvider {
	
	/// Tries to coerce a given generated theme to the specified theme format.
	///
	/// Coercion to intermediate theme format is lossless (data is not touched).
	///
	/// - Important: Will apply *color correction* when converting to Xcode theme
	/// format (if enabled in command configuration).
	///
	public static func coercedTheme(_ intermediateTheme: IntermediateTheme, to format: ThemeFormat) throws -> Theme {
		switch format {
		case .intermediate:
			return intermediateTheme
		case .xcode:
			return try xcodeTheme(from: intermediateTheme)
		case .textmate:
			return try textMateTheme(from: intermediateTheme)
		case .vscode:
			return try visualStudioCodeTheme(from: intermediateTheme)
		}
	}
	
	/// Tries to convert any given theme to an intermediate theme.
	public static func coercedIntermediateTheme(from theme: Theme) throws -> IntermediateTheme {
		switch theme {
		case let intermediateTheme as IntermediateTheme:
			return intermediateTheme
		case let xcodeTheme as XcodeTheme:
			return try intermediateTheme(from: xcodeTheme)
		case let visualStudioCodeTheme as VisualStudioCodeTheme:
			return try intermediateTheme(from: visualStudioCodeTheme)
		default:
			throw ThemeModelingError(kind: .unsupported, description: "Can not convert theme of type '\(type(of: theme))' to intermediate theme for unified coercion.")
		}
	}
	
}
