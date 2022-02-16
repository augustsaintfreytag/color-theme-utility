//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 10/02/2022.
//

import Foundation

public struct TextMateTheme: Theme, CustomPropertyEnumerable {
	
	public typealias Setting = TextMateThemeSetting
	public typealias Settings = TextMateThemeSettings
	
	public let uuid: String
	public let name: String
	public let settings: [Setting]
	
	public static var format: ThemeFormat { .textmate }
	
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
	
	public typealias Settings = TextMateThemeSettings
	
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

public struct TextMateThemeSettings: CustomPropertyEnumerable {
	
	public typealias FontStyle = TextMateThemeFontStyle
	
	public let fontStyle: FontStyle?
	public let background: String?
	public let foreground: String?
	public let caret: String?
	public let invisibles: String?
	public let guide: String?
	public let hoverHighlight: String?
	public let referenceHighlight: String?
	public let lineHighlight: String?
	public let lineHighlightBackground: String?
	public let rangeHighlight: String?
	public let rangeHighlightBackground: String?
	public let selection: String?
	public let selectionBackground: String?
	public let selectionForeground: String?
	public let inactiveSelection: String?
	public let selectionHighlight: String?
	public let findRangeHighlight: String?
	public let findMatchHighlight: String?
	public let currentFindMatchHighlight: String?
	public let wordHighlight: String?
	public let wordHighlightStrong: String?
	public let wordHighlightBackground: String?
	public let activeLinkForeground: String?
	public let gotoDefinitionLinkForeground: String?
	
}

extension TextMateThemeSettings {
	
	public init(fontStyle: FontStyle? = nil, background: String? = nil, foreground: String? = nil) {
		self.init(
			fontStyle: fontStyle,
			background: background,
			foreground: foreground,
			caret: nil,
			invisibles: nil,
			guide: nil,
			hoverHighlight: nil,
			referenceHighlight: nil,
			lineHighlight: nil,
			lineHighlightBackground: nil,
			rangeHighlight: nil,
			rangeHighlightBackground: nil,
			selection: nil,
			selectionBackground: nil,
			selectionForeground: nil,
			inactiveSelection: nil,
			selectionHighlight: nil,
			findRangeHighlight: nil,
			findMatchHighlight: nil,
			currentFindMatchHighlight: nil,
			wordHighlight: nil,
			wordHighlightStrong: nil,
			wordHighlightBackground: nil,
			activeLinkForeground: nil,
			gotoDefinitionLinkForeground: nil
		)
	}
	
}

extension TextMateThemeSettings: Codable {
	
	enum CodingKeys: String, CodingKey {
		case fontStyle = "fontStyle"
		case background = "background"
		case foreground = "foreground"
		case caret = "caret"
		case invisibles = "invisibles"
		case guide = "guide"
		case hoverHighlight = "hoverHighlight"
		case referenceHighlight = "referenceHighlight"
		case lineHighlight = "lineHighlight"
		case lineHighlightBackground = "lineHighlightBackground"
		case rangeHighlight = "rangeHighlight"
		case rangeHighlightBackground = "rangeHighlightBackground"
		case selection = "selection"
		case selectionBackground = "selectionBackground"
		case selectionForeground = "selectionForeground"
		case inactiveSelection = "inactiveSelection"
		case selectionHighlight = "selectionHighlight"
		case findRangeHighlight = "findRangeHighlight"
		case findMatchHighlight = "findMatchHighlight"
		case currentFindMatchHighlight = "currentFindMatchHighlight"
		case wordHighlight = "wordHighlight"
		case wordHighlightStrong = "wordHighlightStrong"
		case wordHighlightBackground = "wordHighlightBackground"
		case activeLinkForeground = "activeLinkForeground"
		case gotoDefinitionLinkForeground = "gotoDefinitionLinkForeground"
	}
	
}

// MARK: Font Style

public enum TextMateThemeFontStyle: String, Codable {
	
	case regular
	case italic
	case bold
	case underline
	
}
