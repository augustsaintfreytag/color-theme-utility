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
	
	public typealias SettingKey = TextMateThemeSettingKey
	public typealias Settings = [SettingKey: String]
	
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

public enum TextMateThemeSettingKey: String, Codable, CaseIterable {
	case fontStyle
	case background
	case activeBackground
	case inactiveBackground
	case hoverBackground
	case hoverBorder
	case secondaryBackground
	case secondaryForeground
	case activeBorderTop
	case foreground
	case activeForeground
	case inactiveForeground
	case descriptionForeground
	case placeholderForeground
	case border
	case activeBorder
	case shadow
	case caret
	case invisibles
	case guide
	case hover
	case hoverHighlight
	case focusBackground
	case focusBorder
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
	case activeSelectionBackground
	case inactiveSelectionBackground
	case findRangeHighlight
	case findMatchHighlight
	case findMatchBackground
	case findMatchHighlightBackground
	case findMatchBorder
	case currentFindMatchHighlight
	case wordHighlight
	case wordHighlightStrong
	case wordHighlightBackground
	case wordHighlightStrongBackground
	case activeLinkForeground
	case gotoDefinitionLinkForeground
	case tabsBorder
	case tabsBackground
	case lastPinnedBorder
	case dropBackground
	case debuggingBackground
	case noFolderBackground
	case checkboxBackground
	case dropdownBackground
	case listBackground
	case resizeBorder
	case errorBackground
	case errorBorder
	case warningBackground
	case warningBorder
	case infoBackground
	case infoBorder
	case addedBackground
	case modifiedBackground
	case deletedBackground
	case modifiedResourceForeground
	case deletedResourceForeground
	case untrackedResourceForeground
	case ignoredResourceForeground
	case conflictingResourceForeground
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
