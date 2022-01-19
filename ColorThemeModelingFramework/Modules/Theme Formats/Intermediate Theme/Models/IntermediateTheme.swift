//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

/// A color theme as an intermediate model between domain-specific theme
/// structures, usable as an exchange format for conversion.
public struct IntermediateTheme: Theme, Codable, CustomPropertyEnumerable {
	
	public static var format: ThemeFormat { .intermediate }
	public static var defaultFormat: String { "CTU Intermediate Theme Format" }
	public static var defaultVersion: String { "1.0" }
	
	public let _format: String
	public let _version: String
	
	public let foreground: Color
	public let background: Color
	public let selectionBackground: Color
	public let activeLineBackground: Color
	public let insertionPoint: Color
	public let instructionPointer: Color
	
	public let comment: Color
	public let commentDocumentation: Color
	public let commentSection: Color
	public let commentSectionHeader: Color
	
	public let keyword: Color
	public let declarationAny: Color
	public let declarationType: Color
	public let functionProject: Color
	public let functionSystem: Color
	public let functionParameter: Color
	public let preprocessorStatement: Color
	public let preprocessorProject: Color
	public let preprocessorSystem: Color
	public let constantProject: Color
	public let constantSystem: Color
	public let variableProject: Color
	public let variableSystem: Color
	public let globalTypeProject: Color
	public let globalTypeSystem: Color
	public let referenceTypeProject: Color
	public let referenceTypeSystem: Color
	public let valueTypeProject: Color
	public let valueTypeSystem: Color
	public let attribute: Color
	public let module: Color
	
	public let number: Color
	public let string: Color
	public let character: Color
	public let url: Color
	
}

extension IntermediateTheme {
	
	public func transformed(_ block: (_ keyPath: KeyPath<IntermediateTheme, Color>, _ color: Color) -> Color) -> IntermediateTheme {
		return IntermediateTheme(
			_format: _format,
			_version: _version,
			foreground: block(\.foreground, foreground),
			background: block(\.background, background),
			selectionBackground: block(\.selectionBackground, selectionBackground),
			activeLineBackground: block(\.activeLineBackground, activeLineBackground),
			insertionPoint: block(\.insertionPoint, insertionPoint),
			instructionPointer: block(\.instructionPointer, instructionPointer),
			comment: block(\.comment, comment),
			commentDocumentation: block(\.commentDocumentation, commentDocumentation),
			commentSection: block(\.commentSection, commentSection),
			commentSectionHeader: block(\.commentSectionHeader, commentSectionHeader),
			keyword: block(\.keyword, keyword),
			declarationAny: block(\.declarationAny, declarationAny),
			declarationType: block(\.declarationType, declarationType),
			functionProject: block(\.functionProject, functionProject),
			functionSystem: block(\.functionSystem, functionSystem),
			functionParameter: block(\.functionParameter, functionParameter),
			preprocessorStatement: block(\.preprocessorStatement, preprocessorStatement),
			preprocessorProject: block(\.preprocessorProject, preprocessorProject),
			preprocessorSystem: block(\.preprocessorSystem, preprocessorSystem),
			constantProject: block(\.constantProject, constantProject),
			constantSystem: block(\.constantSystem, constantSystem),
			variableProject: block(\.variableProject, variableProject),
			variableSystem: block(\.variableSystem, variableSystem),
			globalTypeProject: block(\.globalTypeProject, globalTypeProject),
			globalTypeSystem: block(\.globalTypeSystem, globalTypeSystem),
			referenceTypeProject: block(\.referenceTypeProject, referenceTypeProject),
			referenceTypeSystem: block(\.referenceTypeSystem, referenceTypeSystem),
			valueTypeProject: block(\.valueTypeProject, valueTypeProject),
			valueTypeSystem: block(\.valueTypeSystem, valueTypeSystem),
			attribute: block(\.attribute, attribute),
			module: block(\.module, module),
			number: block(\.number, number),
			string: block(\.string, string),
			character: block(\.character, character),
			url: block(\.url, url)
		)
	}
	
}
