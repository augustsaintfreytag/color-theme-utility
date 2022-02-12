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
	
	private typealias Scope = TextMateScope
	
	// MARK: Intermediate → TextMate
	
	public static func textMateTheme(from theme: IntermediateTheme) throws -> TextMateTheme {
		let id = UUID().uuidString
		let globalSetting = globalTextMateSetting(from: theme)
		
		return TextMateTheme(
			uuid: id,
			name: "Color Theme Utility Output",
			settings: [
				globalSetting,
				setting(scopes: [Scope.Comments.value], color: theme.comment),
				setting(scopes: [Scope.Markup.value], color: theme.commentDocumentation),
				setting(scopes: [Scope.Markup.Heading.value], color: theme.commentSectionHeader),
				
				setting(scopes: [Scope.Keywords.value], color: theme.keyword),
				setting(scopes: [Scope.Storage.value], color: theme.keyword),
				
				setting(scopes: [Scope.Support.Constants.value], color: theme.constantSystem),
				setting(scopes: [Scope.Constants.value], color: theme.constantProject),
				
				setting(scopes: [Scope.Support.Variables.value], color: theme.variableSystem),
				setting(scopes: [Scope.Variables.value], color: theme.variableProject),
				
				setting(scopes: [Scope.Support.Classes.value], color: theme.referenceTypeSystem),
				setting(scopes: [Scope.Entities.Name.Classes.value, Scope.Entities.Other.InheritedClasses.value], color: theme.referenceTypeProject),
				
				setting(scopes: [Scope.Support.Types.value], color: theme.valueTypeSystem),
				setting(scopes: [Scope.Entities.Name.Types.value], color: theme.valueTypeProject),
				
				setting(scopes: [Scope.Support.Functions.value], color: theme.functionSystem),
				setting(scopes: [Scope.Entities.Name.Functions.value], color: theme.functionProject),
				setting(scopes: [Scope.Variables.Parameter.value], color: theme.functionParameter),

				setting(scopes: [Scope.Entities.Name.Tags.value], color: theme.attribute),
				setting(scopes: [Scope.Entities.Other.Attributes.value], color: theme.attribute),
				
				setting(scopes: [Scope.Constants.Character.value], color: theme.character),
				setting(scopes: [Scope.Strings.RegularExpression.value], color: theme.character),
				setting(scopes: [Scope.Strings.value], color: theme.string),
				
				setting(scopes: [Scope.Constants.Numeric.value], color: theme.number)
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
	
	private static func setting(name: String? = nil, scopes: [String], color: Color) -> TextMateThemeSetting {
		let scopeSelector = textMateScopeSelector(scopes)
		let settings = settings(withForegroundColor: color)
		
		return TextMateThemeSetting(name: name, scope: scopeSelector, settings: settings)
	}
	
	private static func settings(withForegroundColor color: Color) -> TextMateThemeSettings {
		return TextMateThemeSettings(foreground: value(color))
	}
	
	// MARK: Color Utility
	
	private static func value(_ color: Color) -> String {
		return color.hexadecimalString
	}
	
}
