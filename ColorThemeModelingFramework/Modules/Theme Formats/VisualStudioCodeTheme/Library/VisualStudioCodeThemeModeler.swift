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
	
	// MARK: Intermediate → TextMate
	
	private static var errorColor: Color { Color(red: 1, green: 0.325, blue: 0.439) }
	
	public static func visualStudioCodeTheme(from theme: IntermediateTheme) throws -> VisualStudioCodeTheme {
		let backgroundColors = cascadingColorSequence(from: theme.background, numberOfColors: 3, skewing: .lighter)

		// MARK: Comments
		
		let commentTokenColors = Theme.TokenColors(
			name: "Comment",
			scope: [
				"comment",
				"punctuation.definition.comment"
			],
			settings: ThemeSettings(foreground: color(theme.comment))
		)
		
		let markupTokenColors = Theme.TokenColors(
			name: "Markup",
			scope: [
				"markup"
			],
			settings: ThemeSettings(foreground: color(theme.commentDocumentation))
		)
		
		let markupHeadingTokenColors = Theme.TokenColors(
			name: "Markup",
			scope: [
				"markup.heading"
			],
			settings: ThemeSettings(foreground: color(theme.commentSectionHeader))
		)
		
		// TODO: Define separate/predefined colors for inserted/deleted/changed.
		
		let markupInsertedTokenColors = Theme.TokenColors(
			name: "Inserted",
			scope: [
				"markup.inserted"
			],
			settings: ThemeSettings(foreground: color(theme.commentSection))
		)
		
		let markupDeletedTokenColors = Theme.TokenColors(
			name: "Deleted",
			scope: [
				"markup.deleted"
			],
			settings: ThemeSettings(foreground: color(theme.commentSection))
		)
		
		let markupChangedTokenColors = Theme.TokenColors(
			name: "Changed",
			scope: [
				"markup.changed"
			],
			settings: ThemeSettings(foreground: color(theme.commentSection))
		)
		
		// MARK: Keywords
		
		let keywordTokenColors = Theme.TokenColors(
			name: "Keyword, Storage",
			scope: [
				"keyword",
				"storage.type",
				"storage.modifier"
			],
			settings: ThemeSettings(foreground: color(theme.keyword))
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
			settings: ThemeSettings(foreground: color(theme.keyword))
		)
		
		// MARK: Constants
		
		let constantProjectTokenColor = Theme.TokenColors(
			name: "Constant",
			scope: [
				"constant"
			],
			settings: ThemeSettings(foreground: color(theme.constantProject))
		)
		
		let constantSystemTokenColors = Theme.TokenColors(
			name: "Built-in Constant",
			scope: [
				"support.constant",
				"constant.other",
				"constant.other.symbol",
				"constant.other.key"
			],
			settings: ThemeSettings(foreground: color(theme.constantSystem))
		)
		
		let unitTokenColors = Theme.TokenColors(
			name: "Number, Constant, Function Argument, Tag Attribute, Embedded",
			scope: [
				"constant.numeric",
				"constant.language",
				"support.constant",
				"constant.character",
				"constant.escape",
				"variable.parameter",
				"keyword.other.unit",
				"keyword.other"
			],
			settings: ThemeSettings(foreground: color(theme.constantSystem))
		)
		
		// MARK: Variables
		
		let variableProjectTokenColors = Theme.TokenColors(
			name: "Variable",
			scope: [
				"variable",
				"string constant.other.placeholder"
			],
			settings: ThemeSettings(foreground: color(theme.variableProject))
		)
		
		let variableSystemTokenColors = Theme.TokenColors(
			name: "Built-in Variable",
			scope: [
				"support.variable",
				"meta.block variable.other"
			],
			settings: ThemeSettings(foreground: color(theme.variableSystem))
		)
		
		// MARK: Global Types
		
		let typeTokenColors = Theme.TokenColors(
			name: "Global Type",
			scope: [
				"support.type"
			],
			settings: ThemeSettings(foreground: color(theme.globalTypeSystem))
		)
		
		let decoratorTokenColors = Theme.TokenColors(
			name: "Decorator",
			scope: [
				"tag.decorator.js entity.name.tag.js",
				"tag.decorator.js punctuation.definition.tag.js"
			],
			settings: ThemeSettings(foreground: color(theme.globalTypeSystem))
		)
		
		// MARK: Reference Types
		
		let referenceTypeProjectTokenColors = Theme.TokenColors(
			name: "Reference Type",
			scope: [
				"entity.name.class",
				"entity.other.inherited-class",
				"support.type.sys-types"
			],
			settings: ThemeSettings(foreground: color(theme.referenceTypeProject))
		)
		
		let referenceTypeSystemTokenColors = Theme.TokenColors(
			name: "Built-in Reference Type",
			scope: [
				"support.class",
				"support.type.sys-types"
			],
			settings: ThemeSettings(foreground: color(theme.referenceTypeSystem))
		)
		
		let constructorTokenColors = Theme.TokenColors(
			name: "Constructor",
			scope: [
				"meta.class-method.js entity.name.function.js",
				"variable.function.constructor"
			],
			settings: ThemeSettings(foreground: color(theme.declarationAny))
		)
		
		// MARK: Value Types
		
		let valueTypeProjectTokenColors = Theme.TokenColors(
			name: "Value Type",
			scope: [
				"entity.name.type",
				"entity.name.type.struct"
			],
			settings: ThemeSettings(foreground: color(theme.valueTypeProject))
		)
		
		let valueTypeSystemTokenColors = Theme.TokenColors(
			name: "Built-in Value Type",
			scope: [
				"support.type"
			],
			settings: ThemeSettings(foreground: color(theme.valueTypeSystem))
		)
		
		// MARK: Declarations
		
		let variableDeclarationTokenColors = Theme.TokenColors(
			name: "Value Declaration",
			scope: [
				"variable.object.property",
				"constant.object.property"
			],
			settings: ThemeSettings(foreground: color(theme.declarationAny))
		)
		
		let typeDeclarationTokenColors = Theme.TokenColors(
			name: "Type Declaration",
			scope: [
				"entity.name.type.typealias",
				"entity.name.type.protocol"
			],
			settings: ThemeSettings(foreground: color(theme.declarationType))
		)
		
		// MARK: Functions
		
		let functionProjectTokenColors = Theme.TokenColors(
			name: "Function, Special Method",
			scope: [
				"entity.name.function",
				"meta.function-call",
				"variable.function"
			],
			settings: ThemeSettings(foreground: color(theme.functionProject))
		)
		
		let functionSystemTokenColors = Theme.TokenColors(
			name: "Function, Special Method",
			scope: [
				"support.function",
				"keyword.other.special-method"
			],
			settings: ThemeSettings(foreground: color(theme.functionSystem))
		)
		
		let languageMethodTokenColors = Theme.TokenColors(
			name: "Language Methods",
			scope: [
				"variable.language"
			],
			settings: ThemeSettings(foreground: color(theme.functionSystem))
		)
		
		// MARK: Attributes
		
		let attributeTokenColors = Theme.TokenColors(
			name: "Attributes",
			scope: [
				"entity.other.attribute-name"
			],
			settings: ThemeSettings(foreground: color(theme.attribute))
		)
		
		// MARK: Modules
		
		let moduleTokenColors = Theme.TokenColors(
			name: "Modules",
			scope: [
				"entity.name.module.js",
				"variable.import.parameter.js",
				"variable.other.class.js",
				"support.other.namespace.use.php",
				"meta.use.php",
				"support.other.namespace.php"
			],
			settings: ThemeSettings(foreground: color(theme.module))
		)
		
		// MARK: Strings
		
		let stringTokenColors = Theme.TokenColors(
			name: "String, Symbols, Inherited Class, Markup Heading",
			scope: [
				"string",
				"markup.inserted.git_gutter",
				"meta.group.braces.curly constant.other.object.key.js string.unquoted.label.js"
			],
			settings: ThemeSettings(foreground: color(theme.string))
		)
		
		let characterTokenColors = Theme.TokenColors(
			name: "Characters",
			scope: [
				"constant.character"
			],
			settings: ThemeSettings(foreground: color(theme.character))
		)
		
		let regularExpressionTokenColors = Theme.TokenColors(
			name: "Regular Expressions",
			scope: [
				"string.regexp"
			],
			settings: ThemeSettings(foreground: color(theme.character))
		)
		
		// MARK: URLs
		
		let urlTokenColors = Theme.TokenColors(
			name: "URL",
			scope: [
				"*url*",
				"*link*",
				"*uri*"
			],
			settings: ThemeSettings(foreground: color(theme.url))
		)
		
		let variableLinkTokenColors = Theme.TokenColors(
			name: "Other Variable, String Link",
			scope: [
				"support.other.variable",
				"string.other.link"
			],
			settings: ThemeSettings(foreground: color(theme.url))
		)
		
		// MARK: Numbers
		
		let numberTokenColors = Theme.TokenColors(
			name: "Number",
			scope: [
				"constant.numeric"
			],
			settings: ThemeSettings(foreground: color(theme.number))
		)
		
		// MARK: Special: Tags
		
		let tagTokenColors = Theme.TokenColors(
			name: "Tag",
			scope: [
				"entity.name.tag",
				"meta.tag.sgml",
				"markup.deleted.git_gutter"
			],
			settings: ThemeSettings(foreground: color(theme.declarationAny))
		)
		
		// MARK: Special: HTML
		
		let attributeHTMLTokenColors = Theme.TokenColors(
			name: "HTML Attributes",
			scope: [
				"text.html.basic entity.other.attribute-name.html",
				"text.html.basic entity.other.attribute-name"
			],
			settings: ThemeSettings(foreground: color(theme.variableSystem))
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
			settings: ThemeSettings(foreground: color(theme.declarationAny))
		)
		
		// MARK: Errors
		
		let invalidTokenColors = Theme.TokenColors(
			name: "Invalid",
			scope: [
				"invalid",
				"invalid.illegal"
			],
			settings: ThemeSettings(foreground: color(errorColor))
		)
		
		return VisualStudioCodeTheme(
			name: "Color Theme Utility Output",
			type: .dark,
			colors: [
				key(.editor, .background): color(theme.background),
				key(.editor, .foreground): color(theme.foreground),
				key(.activityBarBadge, .background): color(backgroundColors[1])
			],
			tokenColors: [
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
				typeTokenColors,
				decoratorTokenColors,
				referenceTypeProjectTokenColors,
				referenceTypeSystemTokenColors,
				constructorTokenColors,
				valueTypeProjectTokenColors,
				valueTypeSystemTokenColors,
				variableDeclarationTokenColors,
				typeDeclarationTokenColors,
				functionProjectTokenColors,
				functionSystemTokenColors,
				languageMethodTokenColors,
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
		)
	}
	
	private static func color(_ color: Color) -> String {
		return color.hexadecimalString
	}
	
	private static func key(_ root: Theme.ColorRoot, _ settings: Theme.TokenColors.Settings.CodingKeys) -> String {
		return "\(root.rawValue).\(settings.rawValue)"
	}
	
}


