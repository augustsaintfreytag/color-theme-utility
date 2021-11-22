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
	
	public let format: String
	public let version: String
	
	public let foreground: Color
	public let background: Color
	public let selectionBackground: Color
	public let activeLineBackground: Color
	public let insertionPoint: Color
	
	public let comment: Color
	public let commentDocumentation: Color
	public let commentSection: Color
	public let commentSectionHeader: Color
	
	public let keyword: Color
	public let declarationType: Color
	public let declarationAny: Color
	public let functionProject: Color
	public let functionSystem: Color
	public let functionParameter: Color
	public let preprocessorProject: Color
	public let preprocessorSystem: Color
	public let constantProject: Color
	public let constantSystem: Color
	public let variableProject: Color
	public let variableSystem: Color
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
