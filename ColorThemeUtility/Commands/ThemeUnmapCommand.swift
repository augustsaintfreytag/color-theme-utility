//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling

protocol ThemeUnmapCommand: CommandFragment,
							ArgumentTransformingCommand,
							ThemeCoercionProvider,
							ColorPrinter {}

extension ThemeUnmapCommand {

	/// Takes in an existing intermediate theme and extract unskewed color values
	/// to produce the initial 10 colors used to generate the theme.
	///
	/// This process may be *lossy* when defining base colors, generating a theme and
	/// unmapping the base colors from the generated output in certain formats. The
	/// process is lossless for the intermediate theme format.
	func unmapTheme() throws {
		let inputTheme = try inputThemeFileFromArguments()
		let intermediateTheme = try Self.coercedIntermediateTheme(from: inputTheme)
		let colors = Self.colorSequence(from: intermediateTheme)
		
		if humanReadable {
			for (index, color) in colors.enumerated() {
				Self.printColor(color, description: "Color \(String(format: "%02d", index + 1))")
			}
		} else {
			let colorDescriptions = colors.map { color in color.hexadecimalString }
			let format: ColorCollectionFormat = {
				guard case let .colorCollection(format: colorCollectionFormat) = outputFormat else {
					return .parameter
				}
				
				return colorCollectionFormat
			}()
			
			switch format {
			case .parameter:
				print(colorDescriptions.joined(separator: ", "))
			case .json:
				let encoder = JSONEncoder()
				let data = try! encoder.encode(colorDescriptions)
				print(String(data: data, encoding: .utf8)!)
			}
		}
	}
	
}
