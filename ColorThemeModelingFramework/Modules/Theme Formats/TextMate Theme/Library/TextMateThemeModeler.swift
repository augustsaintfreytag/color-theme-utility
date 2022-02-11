//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 10/02/2022.
//

import Foundation

/// Functionality to create populated `TextMateTheme` structures from
/// a prepared intermediate theme model.
public protocol TextMateThemeModeler: ColorExtrapolator {}

extension TextMateThemeModeler {
	
	// MARK: Intermediate → TextMate
	
	public static func textMateTheme(from theme: IntermediateTheme) throws -> TextMateTheme {
		let id = UUID().uuidString
		let globalSetting = globalTextMateSetting(from: theme)
		
		return TextMateTheme(
			uuid: id,
			name: "Color Theme Utility Output",
			settings: [
				globalSetting,
				setting(for: TextMateScopes.comment, color: theme.comment),
				setting(for: TextMateScopes.markupQuote, color: theme.commentDocumentation),
				setting(for: TextMateScopes.markupInline, color: theme.commentDocumentation),
				setting(for: TextMateScopes.markupStyling, color: theme.commentDocumentation),
				setting(for: TextMateScopes.markupSetextHeader, color: theme.commentSectionHeader),
				setting(for: TextMateScopes.keyword, color: theme.keyword),
				setting(for: TextMateScopes.builtInConstant, color: theme.constantSystem),
				setting(for: TextMateScopes.libraryConstant, color: theme.constantSystem),
				setting(for: TextMateScopes.userDefinedConstant, color: theme.constantProject),
				setting(for: TextMateScopes.libraryVariable, color: theme.variableSystem),
				setting(for: TextMateScopes.variable, color: theme.variableProject),
				setting(for: TextMateScopes.libraryClassType, color: theme.referenceTypeSystem),
				setting(for: TextMateScopes.inheritedClassType, color: theme.referenceTypeProject),
				setting(for: TextMateScopes.classType, color: theme.referenceTypeProject),
				setting(for: TextMateScopes.libraryFunctionType, color: theme.functionSystem),
				setting(for: TextMateScopes.functionType, color: theme.functionProject),
				setting(for: TextMateScopes.functionParameter, color: theme.functionParameter),
				setting(for: TextMateScopes.tag, color: theme.attribute),
				setting(for: TextMateScopes.tagAttribute, color: theme.attribute),
				setting(for: TextMateScopes.string, color: theme.string),
				setting(for: TextMateScopes.number, color: theme.number),
			]
		)
	}
	
	private static func globalTextMateSetting(from theme: IntermediateTheme) -> TextMateThemeSetting {
		let selectionColors = Self.cascadingColorSequence(from: theme.selectionBackground, numberOfColors: 3, skewing: .lighter)
		let settings = TextMateThemeSettings(
			background: value(theme.background),
			foreground: value(theme.foreground),
			caret: value(theme.insertionPoint),
			invisibles: value(theme.comment),
			guide: nil,
			hoverHighlight: nil,
			referenceHighlight: nil,
			lineHighlight: value(theme.activeLineBackground),
			rangeHighlight: value(theme.activeLineBackground),
			selection: value(theme.selectionBackground),
			inactiveSelection: value(theme.selectionBackground),
			selectionHighlight: value(selectionColors[1]),
			findRangeHighlight: value(selectionColors[2]),
			findMatchHighlight: value(selectionColors[2]),
			currentFindMatchHighlight: value(selectionColors[3]),
			wordHighlight: value(selectionColors[1]),
			wordHighlightStrong: value(selectionColors[2]),
			activeLinkForeground: value(theme.foreground),
			gotoDefinitionLinkForeground: value(theme.foreground),
			fontStyle: nil
		)
		
		return TextMateThemeSetting(settings)
	}
	
	// MARK: Type Utility
	
	private static func setting(for block: TextMateScopes.SettingBlock, color: Color) -> TextMateThemeSetting {
		let settings = settings(withForegroundColor: color)
		return block(settings)
	}
	
	private static func settings(withForegroundColor color: Color) -> TextMateThemeSettings {
		return TextMateThemeSettings(foreground: value(color))
	}
	
	// MARK: Color Utility
	
	private static func value(_ color: Color) -> String {
		return color.hexadecimalString
	}
	
}
