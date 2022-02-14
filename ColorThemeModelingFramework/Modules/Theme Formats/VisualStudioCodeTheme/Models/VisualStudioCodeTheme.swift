//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation

public struct VisualStudioCodeTheme {
	
	public typealias Appearance = VisualStudioCodeThemeAppearance
	public typealias TokenColors = VisualStudioCodeThemeTokenColors
	
	public let name: String
	public let type: Appearance
	
	public let colors: [String: String]
	public let tokenColors: [TokenColors]
	
}

public enum VisualStudioCodeThemeAppearance: String {
	
	case dark
	case light
	
}

public struct VisualStudioCodeThemeTokenColors {
	
	/// Visual Studio Code uses some of the theme format of the TextMate editor.
	public typealias Settings = TextMateThemeSettings
	
	public let name: String
	public let scope: [String]
	public let settings: Settings
	
}
