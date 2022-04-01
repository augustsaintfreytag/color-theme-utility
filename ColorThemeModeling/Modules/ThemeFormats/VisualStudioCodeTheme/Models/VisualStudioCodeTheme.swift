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

public struct VisualStudioCodeThemeTokenColors {
	
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

extension VisualStudioCodeThemeTokenColors: Codable {
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(name, forKey: .name)
		try container.encode(scope, forKey: .scope)
		
		let codableSettings = settings.reduce(into: [String: String]()) { dictionary, element in
			let (key, value) = element
			dictionary[key.description] = value
		}
		
		try container.encode(codableSettings, forKey: .settings)
	}
	
}

public enum VisualStudioCodeThemeColorRoot: String {
	case editor
	case editorGroup
	case editorGroupHeader
	case editorPane
	case editorLineNumber
	case editorCursor
	case editorWidget
	case editorSuggestWidget
	case editorHoverWidget
	case editorGhostText
	case editorIndentGuide
	case editorLink
	case editorGutter
	case editorWhitespace
	case editorWarning
	case selection
	case sideBySideEditor
	case tab
	case window
	case titleBar
	case panel
	case panelTitle
	case panelSection
	case panelSectionHeader
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
	case statusBar
	case statusBarItem
	case minimap
	case minimapSlider
	case minimapGutter
	case widget
	case notifications
	case diffEditor
}

extension VisualStudioCodeThemeColorRoot: CustomStringConvertible {
	
	public var description: String { rawValue }
	
}
