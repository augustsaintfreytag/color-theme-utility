//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 06/11/2021.
//

import Foundation
import ArgumentParser

enum Mode: String, CaseIterable, ExpressibleByArgument {
	
	case describeColor = "describe-color"
	case convertColor = "convert-color"
	case generatePalette = "generate-palette"
	case describeTheme = "describe-theme"
	case generateTheme = "generate-theme"
	case previewTheme = "preview-theme"
	case convertTheme = "convert-theme"
	case unmapTheme = "unmap-theme"
	
}
