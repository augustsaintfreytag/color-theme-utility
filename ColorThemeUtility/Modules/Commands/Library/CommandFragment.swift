//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling

protocol CommandFragment {
	
	var linesFromStdin: String? { get }
	var lineFromStdin: String? { get }
	
	var mode: Mode { get }
	var inputColors: [String]? { get }
	var inputColorsFromStdin: Bool { get }
	var colorTransform: ColorTransform? { get }
	var disablePaletteTransform: Bool { get }
	var colorCount: Int? { get }
	var inputThemeFile: String? { get }
	var inputThemeContentsFromStdin: Bool { get }
	var outputFormat: OutputFormat? { get }
	var outputDirectory: String? { get }
	var outputThemeName: String? { get }
	var outputThemeDescription: String? { get }
	var previewFormat: PreviewFormat? { get }
	var humanReadable: Bool { get }
	var disableColorCorrectPreview: Bool { get }
	
}
