//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

/// A color theme as an intermediate model between domain-specific theme
/// structures, usable as an exchange format for conversion.
public struct IntermediateTheme: Codable, CustomPropertyEnumerable {
	
	let foreground: Color
	let background: Color
	let selectionBackground: Color
	let activeLineBackground: Color
	let insertionPoint: Color
	
	let comment: Color
	let commentDocumentation: Color
	let commentSection: Color
	let commentSectionHeader: Color
	
	let keyword: Color
	let functionProject: Color
	let functionSystem: Color
	let functionParameter: Color
	let preprocessorProject: Color
	let preprocessorSystem: Color
	let constantProject: Color
	let constantSystem: Color
	let variableProject: Color
	let variableSystem: Color
	let typeProject: Color
	let typeSystem: Color
	let referenceTypeProject: Color
	let referenceTypeSystem: Color
	let valueTypeProject: Color
	let valueTypeSystem: Color
	let enumProject: Color
	let enumSystem: Color
	let declarationType: Color
	let declarationAny: Color
	let attribute: Color
	let module: Color
	
	let number: Color
	let string: Color
	let character: Color
	let url: Color
	
}
