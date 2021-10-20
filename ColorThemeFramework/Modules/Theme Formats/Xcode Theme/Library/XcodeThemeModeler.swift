//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 20/10/2021.
//

import Foundation

/// Functionality to create populated `XcodeTheme` structures from a
/// prepared intermediate theme model or a collection of colors.
public protocol XcodeThemeModeler {}

extension XcodeThemeModeler {
	
	public static func theme(from intermediate: IntermediateTheme) throws -> XcodeTheme {
		fatalError("Not implemented.")
	}
	
}
