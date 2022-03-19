//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling

protocol PaletteGeneratorCommand: CommandFragment,
								  ArgumentTransformingCommand,
								  ColorExtrapolator,
								  ColorPrinter {}

extension PaletteGeneratorCommand {
	
	func generatePalette() throws {
		let color = try inputColorFromArguments()
		let numberOfColors = colorCount ?? 3
		let transform: ColorTransform = colorTransform ?? .lighter
		let palette = Self.cascadingColorSequence(from: color, numberOfColors: numberOfColors, skewing: transform)
		
		for (index, paletteColor) in palette.enumerated() {
			Self.printColor(paletteColor, description: "Palette color #\(index + 1) (\(paletteColor.description))")
		}
	}
	
}
