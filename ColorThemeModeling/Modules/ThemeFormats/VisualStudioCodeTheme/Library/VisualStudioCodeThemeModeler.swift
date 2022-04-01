//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 14/02/2022.
//

import Foundation

/// Functionality to create Visual Studio Code themes from
/// prepared intermediate theme models.
public protocol VisualStudioCodeThemeModeler: ColorExtrapolator, HexadecimalColorParser {}

extension VisualStudioCodeThemeModeler {
	
	private typealias Theme = VisualStudioCodeTheme
	private typealias ThemeSettings = VisualStudioCodeTheme.TokenColors.Settings
	
	private static var defaultThemeName: String { "Color Theme Utility Output" }
	
	private static var markupAddedColor: Color { Color(red: 0.478, green: 0.847, blue: 0.568) }
	private static var markupModifiedColor: Color { Color(red: 0.780, green: 0.573, blue: 0.918) }
	private static var markupDeletedColor: Color { Color(red: 1, green: 0.325, blue: 0.439) }
	
	private static var errorColor: Color { Color(red: 1, green: 0.325, blue: 0.439) }
	
	private static var alphaBorder: ColorValue { 0.35 }
	private static var alphaShadow: ColorValue { 0.5 }
	
	private static var alphaBackgroundLight: ColorValue { 0.15 }
	private static var alphaBackgroundMedium: ColorValue { 0.6 }
	private static var alphaBackgroundStrong: ColorValue { 0.85 }
	
	private static var clearValue: String { value(.black, alpha: 0) }
	
	private static var noValue: String { "" }
	
	// MARK: Intermediate → Visual Studio Code
	
	public static func visualStudioCodeTheme(from theme: IntermediateTheme) throws -> VisualStudioCodeTheme {
		let accentColorPrimary = theme.keyword
		let accentColorSecondary = theme.globalTypeProject
		let accentColorTertiary = theme.globalTypeSystem
		
		let foregroundColor = theme.foreground
		let inactiveForegroundColor = transformedColor(from: foregroundColor, applying: (0, 0, -0.3))
		
		let fadedForegroundColor = transformedColor(from: foregroundColor, applying: (0, 0, -0.2))
		let fadedInactiveForegroundColor = transformedColor(from: foregroundColor, applying: (0, -0.1, -0.35))
		
		let backgroundColor = theme.background
		let panelBackgroundColor = transformedColor(from: backgroundColor, applying: (0, 0.01, -0.03))
		let panelHighlightColor = transformedColor(from: panelBackgroundColor, skewing: .lighter, modifier: 1.5)
		let panelHeaderBackgroundColor = transformedColor(from: panelBackgroundColor, skewing: .lighter, modifier: 0.75)
		
		let overlayHeaderBackgroundColor = transformedColor(from: panelHeaderBackgroundColor, skewing: .lighter, modifier: 2)
		let overlayBackgroundColor = transformedColor(from: panelBackgroundColor, skewing: .lighter, modifier: 2)
		let overlayHighlightColor = transformedColor(from: overlayBackgroundColor, skewing: .lighter, modifier: 1)

		let decorationBackgroundColor = transformedColor(from: accentColorTertiary, applying: (0, 0.15, -0.2))
		
		let selectionBackground = theme.selectionBackground
		let inactiveSelectionBackground = transformedColor(from: selectionBackground, applying: (0, 0, -0.1))
		
		let windowDecorationColor = transformedColor(from: backgroundColor, applying: (0, 0, 0.075))
		let inactiveWindowDecorationColor = transformedColor(from: windowDecorationColor, skewing: .darker, modifier: 0.25)
		
		let statusDebuggingColor = transformedColor(from: accentColorTertiary, applying: (0, 0.075, -0.2))
		let statusTemporaryColor = transformedColor(from: accentColorTertiary, applying: (0, 0.075, -0.2))
		
		let buttonColorPrimary = transformedColor(from: accentColorPrimary, applying: (0, 0.075, -0.2))
		let buttonColorSecondary = transformedColor(from: accentColorSecondary, applying: (0, 0.075, -0.2))
		
		let hoverColor = transformedColor(from: backgroundColor, skewing: .lighter, modifier: 0.35)
		let borderColor = transformedColor(from: backgroundColor, skewing: .lighter, modifier: 0.35)
		let activeBorderColor = transformedColor(from: accentColorSecondary, skewing: .darker, modifier: 0.5)
		let shadowColor = transformedColor(from: backgroundColor, skewing: .darker, modifier: 1)

		return VisualStudioCodeTheme(
			name: theme._name ?? defaultThemeName,
			type: .dark,
			colors: [
				key(.foreground): value(foregroundColor),
				key(.descriptionForeground): value(fadedForegroundColor),
				key(.focusBorder): value(borderColor, alpha: alphaBorder),
				key(.titleBar, .border): value(borderColor),
				key(.titleBar, .activeBackground): value(windowDecorationColor),
				key(.titleBar, .inactiveBackground): value(inactiveWindowDecorationColor),
				key(.editor, .background): value(backgroundColor),
				key(.editor, .foreground): value(foregroundColor),
				key(.editor, .lineHighlightBackground): value(theme.activeLineBackground),
				key(.editor, .selectionBackground): value(selectionBackground, alpha: alphaBackgroundStrong),
				key(.editor, .inactiveSelectionBackground): value(inactiveSelectionBackground, alpha: alphaBackgroundMedium),
				key(.editor, .findMatchBackground): value(selectionBackground, alpha: alphaBackgroundStrong),
				key(.editor, .findMatchHighlightBackground): value(inactiveSelectionBackground, alpha: alphaBackgroundMedium),
				key(.editorCursor, .foreground): value(theme.insertionPoint),
				key(.editorGroup, .border): value(borderColor),
				key(.editorGroupHeader, .tabsBackground): value(panelBackgroundColor),
				key(.editorGroupHeader, .tabsBorder): value(borderColor),
				key(.editorLineNumber, .foreground): value(fadedInactiveForegroundColor),
				key(.editorLineNumber, .activeForeground): value(fadedForegroundColor),
				key(.editorGutter, .addedBackground): value(markupAddedColor),
				key(.editorGutter, .modifiedBackground): value(markupModifiedColor),
				key(.editorGutter, .deletedBackground): value(markupDeletedColor),
				key(.minimapGutter, .addedBackground): value(markupAddedColor),
				key(.minimapGutter, .modifiedBackground): value(markupModifiedColor),
				key(.minimapGutter, .deletedBackground): value(markupDeletedColor),
				key(.selection, .background): value(selectionBackground, alpha: alphaBackgroundStrong),
				key(.list, .background): value(overlayBackgroundColor),
				key(.list, .focusBackground): value(overlayHighlightColor, alpha: alphaBackgroundMedium),
				key(.list, .hoverBackground): value(overlayHighlightColor, alpha: alphaBackgroundMedium),
				key(.list, .dropBackground): value(overlayHighlightColor, alpha: alphaBackgroundMedium),
				key(.tab, .border): value(borderColor, alpha: alphaBorder),
				key(.tab, .lastPinnedBorder): value(borderColor, alpha: alphaBorder),
				key(.tab, .activeBackground): value(backgroundColor),
				key(.tab, .inactiveBackground): value(panelBackgroundColor),
				key(.tab, .hoverBackground): value(hoverColor),
				key(.tab, .activeBorderTop): value(activeBorderColor),
				key(.activityBar, .border): value(borderColor),
				key(.activityBar, .background): value(panelBackgroundColor),
				key(.activityBar, .foreground): value(foregroundColor),
				key(.activityBar, .inactiveForeground): value(inactiveForegroundColor),
				key(.activityBarBadge, .background): value(decorationBackgroundColor),
				key(.badge, .background): value(decorationBackgroundColor),
				key(.badge, .foreground): value(theme.foreground),
				key(.panel, .background): value(panelBackgroundColor),
				key(.panel, .border): value(borderColor),
				key(.panelSectionHeader, .background): value(panelBackgroundColor),
				key(.sideBar, .background): value(panelBackgroundColor),
				key(.sideBar, .border): value(borderColor),
				key(.sideBarSectionHeader, .background): value(panelHighlightColor),
				key(.sideBarSectionHeader, .border): value(borderColor),
				key(.statusBar, .background): value(windowDecorationColor),
				key(.statusBar, .border): value(borderColor),
				key(.statusBar, .debuggingBackground): value(statusDebuggingColor),
				key(.statusBar, .noFolderBackground): value(statusTemporaryColor),
				key(.widget, .background): value(overlayBackgroundColor),
				key(.widget, .shadow): value(shadowColor, alpha: alphaShadow),
				key(.scrollbar, .shadow): value(shadowColor, alpha: alphaShadow),
				key(.notifications, .background): value(overlayBackgroundColor),
				key(.notifications, .shadow): value(shadowColor, alpha: alphaShadow),
				key(.notifications, .border): value(borderColor, alpha: alphaBorder),
				key(.notificationCenterHeader, .background): value(overlayHeaderBackgroundColor),
				key(.notificationCenterHeader, .hoverBackground): clearValue,
				key(.notificationCenterHeader, .foreground): value(foregroundColor),
				key(.button, .background): value(buttonColorPrimary),
				key(.button, .foreground): value(foregroundColor),
				key(.button, .secondaryBackground): value(buttonColorSecondary),
				key(.button, .secondaryForeground): value(foregroundColor)
			],
			tokenColors: tokenColors(from: theme)
		)
	}
	
	private static func tokenColors(from theme: IntermediateTheme) -> [VisualStudioCodeThemeTokenColors] {
		
		// MARK: Comments
		
		let commentTokenColors = Theme.TokenColors(
			name: "Comment",
			scope: [
				"comment",
				"punctuation.definition.comment"
			],
			settings: [.foreground: value(theme.comment)]
		)
		
		let markupTokenColors = Theme.TokenColors(
			name: "Markup",
			scope: [
				"markup"
			],
			settings: [.foreground: value(theme.commentDocumentation)]
		)
		
		let markupHeadingTokenColors = Theme.TokenColors(
			name: "Markup Heading",
			scope: [
				"markup.heading"
			],
			settings: [.foreground: value(theme.commentSectionHeader)]
		)
		
		let markupInsertedTokenColors = Theme.TokenColors(
			name: "Inserted",
			scope: [
				"markup.inserted"
			],
			settings: [.foreground: value(markupAddedColor)]
		)
		
		let markupDeletedTokenColors = Theme.TokenColors(
			name: "Deleted",
			scope: [
				"markup.deleted"
			],
			settings: [.foreground: value(markupDeletedColor)]
		)
		
		let markupChangedTokenColors = Theme.TokenColors(
			name: "Changed",
			scope: [
				"markup.changed"
			],
			settings: [.foreground: value(markupModifiedColor)]
		)
		
		// MARK: Keywords
		
		let keywordTokenColors = Theme.TokenColors(
			name: "Keyword, Storage",
			scope: [
				"keyword",
				"storage.type",
				"storage.modifier"
			],
			settings: [.foreground: value(theme.keyword)]
		)
		
		let operatorTokenColors = Theme.TokenColors(
			name: "Operator, Misc",
			scope: [
				"keyword.control",
				"constant.other.color",
				"punctuation",
				"meta.tag",
				"punctuation.definition.tag",
				"punctuation.separator.inheritance.php",
				"punctuation.definition.tag.html",
				"punctuation.definition.tag.begin.html",
				"punctuation.definition.tag.end.html",
				"punctuation.section.embedded",
				"keyword.other.template",
				"keyword.other.substitution"
			],
			settings: [.foreground: value(theme.keyword)]
		)
		
		// MARK: Constants
		
		let constantProjectTokenColor = Theme.TokenColors(
			name: "Constant",
			scope: [
				"constant"
			],
			settings: [.foreground: value(theme.constantProject)]
		)
		
		let constantSystemTokenColors = Theme.TokenColors(
			name: "Built-in Constant",
			scope: [
				"support.constant",
				"constant.other",
				"constant.other.symbol",
				"constant.other.key"
			],
			settings: [.foreground: value(theme.constantSystem)]
		)
		
		let unitTokenColors = Theme.TokenColors(
			name: "Number, Constant, Function Argument, Tag Attribute, Embedded",
			scope: [
				"constant.numeric",
				"constant.language",
				"support.constant",
				"constant.character",
				"constant.escape",
				"keyword.other.unit",
				"keyword.other"
			],
			settings: [.foreground: value(theme.constantSystem)]
		)
		
		// MARK: Variables
		
		let variableProjectTokenColors = Theme.TokenColors(
			name: "Variable",
			scope: [
				"variable",
				"string constant.other.placeholder"
			],
			settings: [.foreground: value(theme.variableProject)]
		)
		
		let variableSystemTokenColors = Theme.TokenColors(
			name: "Built-in Variable",
			scope: [
				"support.variable",
				"meta.block variable.other"
			],
			settings: [.foreground: value(theme.variableSystem)]
		)
		
		// MARK: Global Types
		
		let typeSystemTokenColors = Theme.TokenColors(
			name: "Global Type",
			scope: [
				"support.type"
			],
			settings: [.foreground: value(theme.globalTypeSystem)]
		)
		
		let typeProjectTokenColors = Theme.TokenColors(
			name: "Type, Decorator",
			scope: [
				"entity.name.type",
				"tag.decorator.js entity.name.tag.js",
				"tag.decorator.js punctuation.definition.tag.js"
			],
			settings: [.foreground: value(theme.globalTypeProject)]
		)
		
		// MARK: Reference Types
		
		let referenceTypeProjectTokenColors = Theme.TokenColors(
			name: "Reference Type",
			scope: [
				"entity.name.class",
				"entity.other.inherited-class",
				"support.type.sys-types"
			],
			settings: [.foreground: value(theme.referenceTypeProject)]
		)
		
		let referenceTypeSystemTokenColors = Theme.TokenColors(
			name: "Built-in Reference Type",
			scope: [
				"support.class",
				"support.type.sys-types"
			],
			settings: [.foreground: value(theme.referenceTypeSystem)]
		)
		
		let constructorTokenColors = Theme.TokenColors(
			name: "Constructor",
			scope: [
				"meta.class-method.js entity.name.function.js",
				"variable.function.constructor"
			],
			settings: [.foreground: value(theme.declarationAny)]
		)
		
		// MARK: Value Types
		
		let valueTypeProjectTokenColors = Theme.TokenColors(
			name: "Value Type",
			scope: [
				"entity.name.type",
				"entity.name.type.struct"
			],
			settings: [.foreground: value(theme.valueTypeProject)]
		)
		
		let valueTypeSystemTokenColors = Theme.TokenColors(
			name: "Built-in Value Type",
			scope: [
				"support.type"
			],
			settings: [.foreground: value(theme.valueTypeSystem)]
		)
		
		// MARK: Declarations
		
		let variableDeclarationTokenColors = Theme.TokenColors(
			name: "Value Declaration",
			scope: [
				"variable.object.property",
				"constant.object.property"
			],
			settings: [.foreground: value(theme.declarationAny)]
		)
		
		let typeDeclarationTokenColors = Theme.TokenColors(
			name: "Type Declaration",
			scope: [
				"entity.name.type.typealias",
				"entity.name.type.protocol"
			],
			settings: [.foreground: value(theme.declarationType)]
		)
		
		// MARK: Functions
		
		let functionProjectTokenColors = Theme.TokenColors(
			name: "Function, Special Method",
			scope: [
				"entity.name.function",
				"meta.function-call",
				"variable.function"
			],
			settings: [.foreground: value(theme.functionProject)]
		)
		
		let functionSystemTokenColors = Theme.TokenColors(
			name: "Built-in Function, Special Method",
			scope: [
				"support.function",
				"keyword.other.special-method"
			],
			settings: [.foreground: value(theme.functionSystem)]
		)
		
		let functionParameterTokenColors = Theme.TokenColors(
			name: "Function Parameter",
			scope: [
				"variable.parameter"
			],
			settings: [.foreground: value(theme.functionParameter)]
		)
		
		let languageMethodTokenColors = Theme.TokenColors(
			name: "Language Methods",
			scope: [
				"variable.language"
			],
			settings: [.foreground: value(theme.functionSystem)]
		)
		
		// MARK: Attributes
		
		let attributeTokenColors = Theme.TokenColors(
			name: "Attribute",
			scope: [
				"entity.other.attribute-name"
			],
			settings: [.foreground: value(theme.attribute)]
		)
		
		// MARK: Modules
		
		let moduleTokenColors = Theme.TokenColors(
			name: "Module, Import",
			scope: [
				"entity.name.module",
				"variable.import.parameter",
				"variable.other.class",
				"support.other.namespace.use.php",
				"meta.use.php",
				"support.other.namespace.php"
			],
			settings: [.foreground: value(theme.module)]
		)
		
		// MARK: Preprocessor
		
		let preprocessorProjectTokenColors = Theme.TokenColors(
			name: "Preprocessor",
			scope: [
				"entity.name.function.preprocessor"
			],
			settings: [.foreground: value(theme.preprocessorProject)]
		)
		
		let preprocessorSystemTokenColors = Theme.TokenColors(
			name: "Built-in Preprocessor",
			scope: [
				"comment.block.preprocessor",
				"meta.preprocessor",
				"support.*.preprocessor"
			],
			settings: [.foreground: value(theme.preprocessorSystem)]
		)
		
		// MARK: Strings
		
		let stringTokenColors = Theme.TokenColors(
			name: "String",
			scope: [
				"string",
				"markup.inserted.git_gutter",
				"meta.group.braces.curly constant.other.object.key.js string.unquoted.label.js"
			],
			settings: [.foreground: value(theme.string)]
		)
		
		let characterTokenColors = Theme.TokenColors(
			name: "Character",
			scope: [
				"constant.character"
			],
			settings: [.foreground: value(theme.character)]
		)
		
		let regularExpressionTokenColors = Theme.TokenColors(
			name: "Regular Expressions",
			scope: [
				"string.regexp"
			],
			settings: [.foreground: value(theme.character)]
		)
		
		// MARK: URLs
		
		let urlTokenColors = Theme.TokenColors(
			name: "URL",
			scope: [
				"*url*",
				"*link*",
				"*uri*"
			],
			settings: [.foreground: value(theme.url)]
		)
		
		let variableLinkTokenColors = Theme.TokenColors(
			name: "Other Variable, String Link",
			scope: [
				"support.other.variable",
				"string.other.link"
			],
			settings: [.foreground: value(theme.url)]
		)
		
		// MARK: Numbers
		
		let numberTokenColors = Theme.TokenColors(
			name: "Number",
			scope: [
				"constant.numeric"
			],
			settings: [.foreground: value(theme.number)]
		)
		
		// MARK: Special: Tags
		
		let tagTokenColors = Theme.TokenColors(
			name: "Tag",
			scope: [
				"entity.name.tag",
				"meta.tag.sgml",
				"markup.deleted.git_gutter"
			],
			settings: [.foreground: value(theme.declarationAny)]
		)
		
		// MARK: Special: HTML
		
		let attributeHTMLTokenColors = Theme.TokenColors(
			name: "HTML Attributes",
			scope: [
				"text.html.basic entity.other.attribute-name.html",
				"text.html.basic entity.other.attribute-name"
			],
			settings: [.foreground: value(theme.variableSystem)]
		)
		
		// MARK: Special: Styles
		
		let styleClassTokenColors = Theme.TokenColors(
			name: "CSS Class and Support",
			scope: [
				"source.css support.type.property-name",
				"source.sass support.type.property-name",
				"source.scss support.type.property-name",
				"source.less support.type.property-name",
				"source.stylus support.type.property-name",
				"source.postcss support.type.property-name"
			],
			settings: [.foreground: value(theme.declarationAny)]
		)
		
		// MARK: Errors
		
		let invalidTokenColors = Theme.TokenColors(
			name: "Invalid",
			scope: [
				"invalid",
				"invalid.illegal"
			],
			settings: [.foreground: value(errorColor)]
		)
		
		return [
			commentTokenColors,
			markupTokenColors,
			markupHeadingTokenColors,
			markupInsertedTokenColors,
			markupDeletedTokenColors,
			markupChangedTokenColors,
			keywordTokenColors,
			operatorTokenColors,
			constantProjectTokenColor,
			constantSystemTokenColors,
			unitTokenColors,
			variableProjectTokenColors,
			variableSystemTokenColors,
			typeSystemTokenColors,
			typeProjectTokenColors,
			referenceTypeProjectTokenColors,
			referenceTypeSystemTokenColors,
			constructorTokenColors,
			valueTypeProjectTokenColors,
			valueTypeSystemTokenColors,
			variableDeclarationTokenColors,
			typeDeclarationTokenColors,
			functionProjectTokenColors,
			functionSystemTokenColors,
			functionParameterTokenColors,
			languageMethodTokenColors,
			preprocessorProjectTokenColors,
			preprocessorSystemTokenColors,
			attributeTokenColors,
			moduleTokenColors,
			stringTokenColors,
			characterTokenColors,
			regularExpressionTokenColors,
			urlTokenColors,
			variableLinkTokenColors,
			numberTokenColors,
			tagTokenColors,
			attributeHTMLTokenColors,
			styleClassTokenColors,
			invalidTokenColors
		]
	}
	
	// MARK: Visual Studio Code → Intermediate
	
	public static func intermediateTheme(from theme: VisualStudioCodeTheme) throws -> IntermediateTheme {
		let tokenColorsByName = try indexedTokenColors(theme)
		
		let backgroundColor = try color(theme.colors[key(.editor, .background)])
		let foregroundColor = try color(theme.colors[key(.editor, .foreground)])
		
		return IntermediateTheme(
			_format: IntermediateTheme.defaultFormat,
			_version: IntermediateTheme.defaultVersion,
			_name: theme.name,
			foreground: foregroundColor,
			background: backgroundColor,
			selectionBackground: try color(theme.colors[key(.editor, .selectionBackground)]),
			activeLineBackground: try color(theme.colors[key(.editor, .lineHighlightBackground)]),
			insertionPoint: try color(theme.colors[key(.editorCursor, .foreground)]),
			instructionPointer: try color(theme.colors[key(.editor, .lineHighlightBackground)]),
			comment: try color(in: tokenColorsByName, name: "Comment"),
			commentDocumentation: try color(in: tokenColorsByName, name: "Markup"),
			commentSection: try color(in: tokenColorsByName, name: "Markup"),
			commentSectionHeader: try color(in: tokenColorsByName, name: "Markup Heading"),
			keyword: try color(in: tokenColorsByName, name: "Keyword, Storage"),
			declarationAny: try color(in: tokenColorsByName, name: "Value Declaration"),
			declarationType: try color(in: tokenColorsByName, name: "Type Declaration"),
			functionProject: try color(in: tokenColorsByName, name: "Function, Special Method"),
			functionSystem: try color(in: tokenColorsByName, name: "Built-in Function, Special Method"),
			functionParameter: try color(in: tokenColorsByName, name: "Function Parameter"),
			preprocessorStatement: try color(in: tokenColorsByName, name: "Built-in Preprocessor"),
			preprocessorProject: try color(in: tokenColorsByName, name: "Preprocessor"),
			preprocessorSystem: try color(in: tokenColorsByName, name: "Built-in Preprocessor"),
			constantProject: try color(in: tokenColorsByName, name: "Constant"),
			constantSystem: try color(in: tokenColorsByName, name: "Built-in Constant"),
			variableProject: try color(in: tokenColorsByName, name: "Variable"),
			variableSystem: try color(in: tokenColorsByName, name: "Built-in Variable"),
			globalTypeProject: try color(in: tokenColorsByName, name: "Type, Decorator"),
			globalTypeSystem: try color(in: tokenColorsByName, name: "Global Type"),
			referenceTypeProject: try color(in: tokenColorsByName, name: "Reference Type"),
			referenceTypeSystem: try color(in: tokenColorsByName, name: "Built-in Reference Type"),
			valueTypeProject: try color(in: tokenColorsByName, name: "Value Type"),
			valueTypeSystem: try color(in: tokenColorsByName, name: "Built-in Value Type"),
			attribute: try color(in: tokenColorsByName, name: "Attribute"),
			module: try color(in: tokenColorsByName, name: "Module, Import"),
			number: try color(in: tokenColorsByName, name: "Number"),
			string: try color(in: tokenColorsByName, name: "String"),
			character: try color(in: tokenColorsByName, name: "Character"),
			url: try color(in: tokenColorsByName, name: "URL")
		)
	}
	
	private static func indexedTokenColors(_ theme: VisualStudioCodeTheme) throws -> [String: Color] {
		var index = [String: Color]()
		
		for tokenColors in theme.tokenColors {
			guard let primaryColorValue = tokenColors.settings[.foreground] else {
				continue
			}
			
			let primaryColor = try color(primaryColorValue)
			index[tokenColors.name] = primaryColor
		}
		
		return index
	}

	private static func color(in index: [String: Color], name: String) throws -> Color {
		guard let color = index[name] else {
			throw ThemeCodingError(description: "Missing required color for key '\(name)' in theme. May be prevalidation error.")
		}
		
		return color
	}
	
	private static func color(_ value: String?) throws -> Color {
		guard let value = value, let color = Color(fromHexadecimalString: value) else {
			throw ThemeCodingError(description: "Could not decode color from expected hexadecimal value '\(value ?? "<None>")'.")
		}
		
		return color
	}
	
	private static func value(_ color: Color, alpha: ColorValue? = nil) -> String {
		guard let alpha = alpha else {
			return color.hexadecimalString
		}
		
		return color.hexadecimalString + hexadecimalStringComponent(for: alpha)
	}
	
	private static func key(_ root: Theme.ColorRoot, _ setting: Theme.TokenColors.SettingKey) -> String {
		return "\(root.description).\(setting.description)"
	}
	
	private static func key(_ setting: Theme.TokenColors.SettingKey) -> String {
		return setting.description
	}
	
}
