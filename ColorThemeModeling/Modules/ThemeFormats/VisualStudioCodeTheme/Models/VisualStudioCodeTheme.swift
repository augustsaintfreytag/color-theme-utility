//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation

public struct VisualStudioCodeTheme: Theme, Codable, CustomPropertyEnumerable {
	
	public var format: ThemeFormat { .vscode }
	
	public typealias Appearance = VisualStudioCodeThemeAppearance
	public typealias TokenColors = VisualStudioCodeThemeTokenColors
	public typealias ColorRoot = VisualStudioCodeThemeColorRoot
	
	public let name: String
	public let type: Appearance
	
	public let colors: [String: String]
	public let tokenColors: [TokenColors]
	
}

public enum VisualStudioCodeThemeAppearance: String, Codable {
	
	case dark
	case light
	
}

public struct VisualStudioCodeThemeTokenColors: Codable {
	
	/// The key for a specific setting used to color elements.
	///
	/// Visual Studio Code shares some of the theme format of the
	/// TextMate editor and the setting key is equal in both.
	public typealias SettingKey = TextMateThemeSettingKey
	
	public typealias Settings = [SettingKey: String]
	
	public let name: String
	public let scope: [String]
	public let settings: Settings
	
}

public enum VisualStudioCodeThemeColorRoot: String {
	case editor
	case editorGroup
	case editorGroupHeader
	case editorPane
	case editorLineNumber
	case editorCursor
	case sideBySideEditor
	case tab
	case window
	case toolbar
	case button
	case dropdown
	case input
	case inputOption
	case inputValidation
	case scrollbar
	case scrollbarSlider
	case badge
	case list
	case tree
	case activityBar
	case activityBarBadge
	case sideBar
	case sideBarTitle
	case sideBarSectionHeader
	case minimap
	case minimapSlider
	case minimapGutter
}
