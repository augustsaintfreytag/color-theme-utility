//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 10/02/2022.
//

import Foundation

public struct TextMateTheme: Theme, CustomPropertyEnumerable {
	
	public typealias Setting = TextMateThemeSetting
	
	public let uuid: String
	public let name: String
	public let settings: [Setting]
	
	public var format: ThemeFormat { .textmate }
	
}

extension TextMateTheme: Codable {
	
	enum CodingKeys: String, CodingKey {
		case uuid = "uuid"
		case name = "name"
		case settings = "settings"
	}
	
}

// MARK: Settings

public struct TextMateThemeSetting: CustomPropertyEnumerable {
		
	public typealias Settings = [TextMateThemeSettingKey: String]
	
	public let name: String?
	public let scope: String?
	public let settings: Settings
	
}

extension TextMateThemeSetting {
	
	init(_ settings: Settings) {
		self.init(name: nil, scope: nil, settings: settings)
	}
	
}

extension TextMateThemeSetting: Codable {
	
	enum CodingKeys: String, CodingKey {
		case name = "name"
		case scope = "scope"
		case settings = "settings"
	}
	
}


public enum TextMateThemeSettingKey: String, Codable {
	case fontStyle
	case background
	case foreground
	case border
	case caret
	case invisibles
	case guide
	case hoverHighlight
	case referenceHighlight
	case lineHighlight
	case lineHighlightBackground
	case rangeHighlight
	case rangeHighlightBackground
	case selection
	case selectionBackground
	case selectionForeground
	case inactiveSelection
	case selectionHighlight
	case findRangeHighlight
	case findMatchHighlight
	case currentFindMatchHighlight
	case wordHighlight
	case wordHighlightStrong
	case wordHighlightBackground
	case activeLinkForeground
	case gotoDefinitionLinkForeground
	case tabsBorder
	case tabsBackground
}

extension TextMateThemeSettingKey: CustomStringConvertible {
	
	public var description: String { rawValue }
	
}

// MARK: Font Style

public enum TextMateThemeFontStyle: String, Codable {
	
	case regular
	case italic
	case bold
	case underline
	
}

extension TextMateThemeFontStyle: CustomStringConvertible {
	
	public var description: String { rawValue }
	
}
