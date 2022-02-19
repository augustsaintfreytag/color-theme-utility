//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 14/02/2022.
//

import Foundation

/// Functionality to create Visual Studio Code themes from
/// prepared intermediate theme models.
public protocol VisualStudioCodeThemeModeler: ColorExtrapolator {}

extension VisualStudioCodeThemeModeler {
	
	private typealias Theme = VisualStudioCodeTheme
	private typealias ThemeSettings = VisualStudioCodeTheme.TokenColors.Settings
	
	private static var defaultThemeName: String { "Color Theme Utility Output" }
	
	private static var markupInsertedColor: Color { Color(red: 0.478, green: 0.847, blue: 0.568) }
	private static var markupUpdatedColor: Color { Color(red: 0.780, green: 0.573, blue: 0.918) }
	private static var markupDeletedColor: Color { Color(red: 1, green: 0.325, blue: 0.439) }
	
	private static var errorColor: Color { Color(red: 1, green: 0.325, blue: 0.439) }
	
	// MARK: Intermediate → Visual Studio Code
	
	public static func visualStudioCodeTheme(from theme: IntermediateTheme) throws -> VisualStudioCodeTheme {
		let backgroundColors = cascadingColorSequence(from: theme.background, numberOfColors: 2, skewing: .lighter)

		return VisualStudioCodeTheme(
			name: theme._name ?? defaultThemeName,
			type: .dark,
			colors: [
				key(.editor, .background): value(theme.background),
				key(.editor, .foreground): value(theme.foreground),
				key(.editorCursor, .foreground): value(theme.insertionPoint),
				key(.editor, .lineHighlightBackground): value(theme.activeLineBackground),
				key(.editor, .selectionBackground): value(theme.selectionBackground),
				key(.activityBarBadge, .background): value(backgroundColors[1]),
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
			settings: ThemeSettings(foreground: value(theme.comment))
		)
		
		let markupTokenColors = Theme.TokenColors(
			name: "Markup",
			scope: [
				"markup"
			],
			settings: ThemeSettings(foreground: value(theme.commentDocumentation))
		)
		
		let markupHeadingTokenColors = Theme.TokenColors(
			name: "Markup Heading",
			scope: [
				"markup.heading"
			],
			settings: ThemeSettings(foreground: value(theme.commentSectionHeader))
		)
		
		let markupInsertedTokenColors = Theme.TokenColors(
			name: "Inserted",
			scope: [
				"markup.inserted"
			],
			settings: ThemeSettings(foreground: value(markupInsertedColor))
		)
		
		let markupDeletedTokenColors = Theme.TokenColors(
			name: "Deleted",
			scope: [
				"markup.deleted"
			],
			settings: ThemeSettings(foreground: value(markupDeletedColor))
		)
		
		let markupChangedTokenColors = Theme.TokenColors(
			name: "Changed",
			scope: [
				"markup.changed"
			],
			settings: ThemeSettings(foreground: value(markupUpdatedColor))
		)
		
		// MARK: Keywords
		
		let keywordTokenColors = Theme.TokenColors(
			name: "Keyword, Storage",
			scope: [
				"keyword",
				"storage.type",
				"storage.modifier"
			],
			settings: ThemeSettings(foreground: value(theme.keyword))
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
			settings: ThemeSettings(foreground: value(theme.keyword))
		)
		
		// MARK: Constants
		
		let constantProjectTokenColor = Theme.TokenColors(
			name: "Constant",
			scope: [
				"constant"
			],
			settings: ThemeSettings(foreground: value(theme.constantProject))
		)
		
		let constantSystemTokenColors = Theme.TokenColors(
			name: "Built-in Constant",
			scope: [
				"support.constant",
				"constant.other",
				"constant.other.symbol",
				"constant.other.key"
			],
			settings: ThemeSettings(foreground: value(theme.constantSystem))
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
			settings: ThemeSettings(foreground: value(theme.constantSystem))
		)
		
		// MARK: Variables
		
		let variableProjectTokenColors = Theme.TokenColors(
			name: "Variable",
			scope: [
				"variable",
				"string constant.other.placeholder"
			],
			settings: ThemeSettings(foreground: value(theme.variableProject))
		)
		
		let variableSystemTokenColors = Theme.TokenColors(
			name: "Built-in Variable",
			scope: [
				"support.variable",
				"meta.block variable.other"
			],
			settings: ThemeSettings(foreground: value(theme.variableSystem))
		)
		
		// MARK: Global Types
		
		let typeSystemTokenColors = Theme.TokenColors(
			name: "Global Type",
			scope: [
				"support.type"
			],
			settings: ThemeSettings(foreground: value(theme.globalTypeSystem))
		)
		
		let typeProjectTokenColors = Theme.TokenColors(
			name: "Type, Decorator",
			scope: [
				"entity.name.type",
				"tag.decorator.js entity.name.tag.js",
				"tag.decorator.js punctuation.definition.tag.js"
			],
			settings: ThemeSettings(foreground: value(theme.globalTypeProject))
		)
		
		// MARK: Reference Types
		
		let referenceTypeProjectTokenColors = Theme.TokenColors(
			name: "Reference Type",
			scope: [
				"entity.name.class",
				"entity.other.inherited-class",
				"support.type.sys-types"
			],
			settings: ThemeSettings(foreground: value(theme.referenceTypeProject))
		)
		
		let referenceTypeSystemTokenColors = Theme.TokenColors(
			name: "Built-in Reference Type",
			scope: [
				"support.class",
				"support.type.sys-types"
			],
			settings: ThemeSettings(foreground: value(theme.referenceTypeSystem))
		)
		
		let constructorTokenColors = Theme.TokenColors(
			name: "Constructor",
			scope: [
				"meta.class-method.js entity.name.function.js",
				"variable.function.constructor"
			],
			settings: ThemeSettings(foreground: value(theme.declarationAny))
		)
		
		// MARK: Value Types
		
		let valueTypeProjectTokenColors = Theme.TokenColors(
			name: "Value Type",
			scope: [
				"entity.name.type",
				"entity.name.type.struct"
			],
			settings: ThemeSettings(foreground: value(theme.valueTypeProject))
		)
		
		let valueTypeSystemTokenColors = Theme.TokenColors(
			name: "Built-in Value Type",
			scope: [
				"support.type"
			],
			settings: ThemeSettings(foreground: value(theme.valueTypeSystem))
		)
		
		// MARK: Declarations
		
		let variableDeclarationTokenColors = Theme.TokenColors(
			name: "Value Declaration",
			scope: [
				"variable.object.property",
				"constant.object.property"
			],
			settings: ThemeSettings(foreground: value(theme.declarationAny))
		)
		
		let typeDeclarationTokenColors = Theme.TokenColors(
			name: "Type Declaration",
			scope: [
				"entity.name.type.typealias",
				"entity.name.type.protocol"
			],
			settings: ThemeSettings(foreground: value(theme.declarationType))
		)
		
		// MARK: Functions
		
		let functionProjectTokenColors = Theme.TokenColors(
			name: "Function, Special Method",
			scope: [
				"entity.name.function",
				"meta.function-call",
				"variable.function"
			],
			settings: ThemeSettings(foreground: value(theme.functionProject))
		)
		
		let functionSystemTokenColors = Theme.TokenColors(
			name: "Built-in Function, Special Method",
			scope: [
				"support.function",
				"keyword.other.special-method"
			],
			settings: ThemeSettings(foreground: value(theme.functionSystem))
		)
		
		let functionParameterTokenColors = Theme.TokenColors(
			name: "Function Parameter",
			scope: [
				"variable.parameter"
			],
			settings: ThemeSettings(foreground: value(theme.functionParameter))
		)
		
		let languageMethodTokenColors = Theme.TokenColors(
			name: "Language Methods",
			scope: [
				"variable.language"
			],
			settings: ThemeSettings(foreground: value(theme.functionSystem))
		)
		
		// MARK: Attributes
		
		let attributeTokenColors = Theme.TokenColors(
			name: "Attribute",
			scope: [
				"entity.other.attribute-name"
			],
			settings: ThemeSettings(foreground: value(theme.attribute))
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
			settings: ThemeSettings(foreground: value(theme.module))
		)
		
		// MARK: Preprocessor
		
		let preprocessorProjectTokenColors = Theme.TokenColors(
			name: "Preprocessor",
			scope: [
				"entity.name.function.preprocessor"
			],
			settings: ThemeSettings(foreground: value(theme.preprocessorProject))
		)
		
		let preprocessorSystemTokenColors = Theme.TokenColors(
			name: "Built-in Preprocessor",
			scope: [
				"comment.block.preprocessor",
				"meta.preprocessor",
				"support.*.preprocessor"
			],
			settings: ThemeSettings(foreground: value(theme.preprocessorSystem))
		)
		
		// MARK: Strings
		
		let stringTokenColors = Theme.TokenColors(
			name: "String",
			scope: [
				"string",
				"markup.inserted.git_gutter",
				"meta.group.braces.curly constant.other.object.key.js string.unquoted.label.js"
			],
			settings: ThemeSettings(foreground: value(theme.string))
		)
		
		let characterTokenColors = Theme.TokenColors(
			name: "Character",
			scope: [
				"constant.character"
			],
			settings: ThemeSettings(foreground: value(theme.character))
		)
		
		let regularExpressionTokenColors = Theme.TokenColors(
			name: "Regular Expressions",
			scope: [
				"string.regexp"
			],
			settings: ThemeSettings(foreground: value(theme.character))
		)
		
		// MARK: URLs
		
		let urlTokenColors = Theme.TokenColors(
			name: "URL",
			scope: [
				"*url*",
				"*link*",
				"*uri*"
			],
			settings: ThemeSettings(foreground: value(theme.url))
		)
		
		let variableLinkTokenColors = Theme.TokenColors(
			name: "Other Variable, String Link",
			scope: [
				"support.other.variable",
				"string.other.link"
			],
			settings: ThemeSettings(foreground: value(theme.url))
		)
		
		// MARK: Numbers
		
		let numberTokenColors = Theme.TokenColors(
			name: "Number",
			scope: [
				"constant.numeric"
			],
			settings: ThemeSettings(foreground: value(theme.number))
		)
		
		// MARK: Special: Tags
		
		let tagTokenColors = Theme.TokenColors(
			name: "Tag",
			scope: [
				"entity.name.tag",
				"meta.tag.sgml",
				"markup.deleted.git_gutter"
			],
			settings: ThemeSettings(foreground: value(theme.declarationAny))
		)
		
		// MARK: Special: HTML
		
		let attributeHTMLTokenColors = Theme.TokenColors(
			name: "HTML Attributes",
			scope: [
				"text.html.basic entity.other.attribute-name.html",
				"text.html.basic entity.other.attribute-name"
			],
			settings: ThemeSettings(foreground: value(theme.variableSystem))
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
			settings: ThemeSettings(foreground: value(theme.declarationAny))
		)
		
		// MARK: Errors
		
		let invalidTokenColors = Theme.TokenColors(
			name: "Invalid",
			scope: [
				"invalid",
				"invalid.illegal"
			],
			settings: ThemeSettings(foreground: value(errorColor))
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
			guard let primaryColorValue = tokenColors.settings.foreground else {
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
	
	private static func value(_ color: Color) -> String {
		return color.hexadecimalString
	}
	
	private static func key(_ root: Theme.ColorRoot, _ settings: Theme.TokenColors.Settings.CodingKeys) -> String {
		return "\(root.rawValue).\(settings.rawValue)"
	}
	
}


