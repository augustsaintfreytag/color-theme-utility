//
//  Color Theme Utility
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
				
				setting(scopes: [Scope.Constants.value], color: theme.constantProject),
				setting(scopes: [Scope.Support.Constants.value], color: theme.constantSystem),
				
				setting(scopes: [Scope.Variables.value], color: theme.variableProject),
				setting(scopes: [Scope.Support.Variables.value], color: theme.variableSystem),
				
				setting(scopes: [Scope.Entities.Name.Classes.value, Scope.Entities.Other.InheritedClasses.value], color: theme.referenceTypeProject),
				setting(scopes: [Scope.Support.Classes.value], color: theme.referenceTypeSystem),
				
				setting(scopes: [Scope.Support.Types.value], color: theme.valueTypeSystem),
				setting(scopes: [Scope.Entities.Name.Types.value, Scope.Entities.Name.Types.Structs.value], color: theme.valueTypeProject),
				
				setting(scopes: [Scope.Entities.Name.Types.Typealias.value], color: theme.declarationType),
				setting(scopes: [Scope.Entities.Name.Types.Protocols.value], color: theme.declarationType),
				
				setting(scopes: [Scope.Variables.Object.Property.value], color: theme.declarationAny),
				setting(scopes: [Scope.Constants.Object.Property.value], color: theme.declarationAny),
				
				setting(scopes: [Scope.Entities.Name.Functions.value], color: theme.functionProject),
				setting(scopes: [Scope.Support.Functions.value], color: theme.functionSystem),
				setting(scopes: [Scope.Variables.Parameter.value], color: theme.functionParameter),
				
				setting(scopes: [Scope.Entities.Other.Attributes.value], color: theme.attribute),
				
				setting(scopes: [Scope.Strings.value], color: theme.string),
				setting(scopes: [Scope.Constants.Character.value], color: theme.character),
				setting(scopes: [Scope.Strings.RegularExpression.value], color: theme.character),
				
				setting(scopes: [Scope.Constants.Numeric.value], color: theme.number)
			]
		)
	}
	
	private static func globalTextMateSetting(from theme: IntermediateTheme) -> TextMateThemeSetting {
		let selectionColors = Self.cascadingColorSequence(from: theme.selectionBackground, numberOfColors: 3, skewing: .lighter)
		let settings = TextMateThemeSettings(
			fontStyle: nil,
			background: color(theme.background),
			foreground: color(theme.foreground),
			caret: color(theme.insertionPoint),
			invisibles: color(theme.comment),
			guide: nil,
			hoverHighlight: nil,
			referenceHighlight: nil,
			lineHighlight: nil,
			lineHighlightBackground: color(theme.activeLineBackground),
			rangeHighlight: nil,
			rangeHighlightBackground: color(theme.activeLineBackground),
			selection: nil,
			selectionBackground: color(selectionColors[0]),
			selectionForeground: nil,
			inactiveSelection: color(theme.selectionBackground),
			selectionHighlight: color(selectionColors[0]),
			findRangeHighlight: color(selectionColors[1]),
			findMatchHighlight: color(selectionColors[1]),
			currentFindMatchHighlight: color(selectionColors[2]),
			wordHighlight: nil,
			wordHighlightStrong: nil,
			wordHighlightBackground: color(selectionColors[1]),
			activeLinkForeground: color(theme.foreground),
			gotoDefinitionLinkForeground: color(theme.foreground)
		)
		
		return TextMateThemeSetting(settings)
	}
	
	// MARK: Type Utility
	
	private static func setting(name: String? = nil, scopes: [String], color: Color) -> TextMateThemeSetting {
		let scopeSelector = textMateScopeSelector(scopes)
		let settings = settings(withForegroundColor: color)
		
		return TextMateThemeSetting(name: name, scope: scopeSelector, settings: settings)
	}
	
	private static func settings(withForegroundColor foregroundColor: Color) -> TextMateThemeSettings {
		return TextMateThemeSettings(foreground: color(foregroundColor))
	}
	
	// MARK: Color Utility
	
	private static func color(_ color: Color) -> String {
		return color.hexadecimalString
	}
	
}
