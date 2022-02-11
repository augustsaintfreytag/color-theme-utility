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
		case name = "name"
		case settings = "settings"
		case uuid = "uuid"
	}
	
}

// MARK: Settings

public struct TextMateThemeSetting {
	
	public let settings: TextMateThemeSettings
	public let name: String?
	public let scope: String?
	
	public init(settings: TextMateThemeSettings, name: String?, scope: String?) {
		self.settings = settings
		self.name = name
		self.scope = scope
	}
	
}

extension TextMateThemeSetting: Codable {
	
	enum CodingKeys: String, CodingKey {
		case settings = "settings"
		case name = "name"
		case scope = "scope"
	}
	
}

public struct TextMateThemeSettings {
	
	public let background: String?
	public let foreground: String?
	public let caret: String?
	public let invisibles: String?
	public let guide: String?
	public let hoverHighlight: String?
	public let referenceHighlight: String?
	public let lineHighlight: String?
	public let rangeHighlight: String?
	public let selection: String?
	public let inactiveSelection: String?
	public let selectionHighlight: String?
	public let findRangeHighlight: String?
	public let findMatchHighlight: String?
	public let currentFindMatchHighlight: String?
	public let wordHighlight: String?
	public let wordHighlightStrong: String?
	public let activeLinkForeground: String?
	public let gotoDefinitionLinkForeground: String?
	public let fontStyle: String?
	
	public init(background: String?, foreground: String?, caret: String?, invisibles: String?, guide: String?, hoverHighlight: String?, referenceHighlight: String?, lineHighlight: String?, rangeHighlight: String?, selection: String?, inactiveSelection: String?, selectionHighlight: String?, findRangeHighlight: String?, findMatchHighlight: String?, currentFindMatchHighlight: String?, wordHighlight: String?, wordHighlightStrong: String?, activeLinkForeground: String?, gotoDefinitionLinkForeground: String?, fontStyle: String?) {
		self.background = background
		self.foreground = foreground
		self.caret = caret
		self.invisibles = invisibles
		self.guide = guide
		self.hoverHighlight = hoverHighlight
		self.referenceHighlight = referenceHighlight
		self.lineHighlight = lineHighlight
		self.rangeHighlight = rangeHighlight
		self.selection = selection
		self.inactiveSelection = inactiveSelection
		self.selectionHighlight = selectionHighlight
		self.findRangeHighlight = findRangeHighlight
		self.findMatchHighlight = findMatchHighlight
		self.currentFindMatchHighlight = currentFindMatchHighlight
		self.wordHighlight = wordHighlight
		self.wordHighlightStrong = wordHighlightStrong
		self.activeLinkForeground = activeLinkForeground
		self.gotoDefinitionLinkForeground = gotoDefinitionLinkForeground
		self.fontStyle = fontStyle
	}
	
}

extension TextMateThemeSettings: Codable {
	
	enum CodingKeys: String, CodingKey {
		case background = "background"
		case foreground = "foreground"
		case caret = "caret"
		case invisibles = "invisibles"
		case guide = "guide"
		case hoverHighlight = "hoverHighlight"
		case referenceHighlight = "referenceHighlight"
		case lineHighlight = "lineHighlight"
		case rangeHighlight = "rangeHighlight"
		case selection = "selection"
		case inactiveSelection = "inactiveSelection"
		case selectionHighlight = "selectionHighlight"
		case findRangeHighlight = "findRangeHighlight"
		case findMatchHighlight = "findMatchHighlight"
		case currentFindMatchHighlight = "currentFindMatchHighlight"
		case wordHighlight = "wordHighlight"
		case wordHighlightStrong = "wordHighlightStrong"
		case activeLinkForeground = "activeLinkForeground"
		case gotoDefinitionLinkForeground = "gotoDefinitionLinkForeground"
		case fontStyle = "fontStyle"
	}
	
}
