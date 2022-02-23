//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling

protocol ThemePreviewCommand: CommandFragment,
							  ArgumentTransformingCommand,
							  TerminalDetector,
							  TerminalThemeColorCorrector,
							  ThemeCoercionProvider {}

extension ThemePreviewCommand {
	
	/// Prints code snippets with applied syntax highlighting using the supplied theme.
	///
	/// Internally coerces theme formats other than intermediate themes to the
	/// intermediate format first and uses the resulting model for the preview.
	func previewTheme() throws {
		let theme: Theme = try inputThemeFileFromArguments()
		var intermediateTheme = try Self.coercedIntermediateTheme(from: theme)
		
		if !disableColorCorrectPreview, let terminal = Self.terminalApplication {
			intermediateTheme = Self.colorCorrectedTheme(intermediateTheme, for: terminal)
		}
		
		let presetString = presetString(for: previewFormat ?? .swift)
		let themedPresetString = presetString.withLineNumbers.withPadding.themedString(with: intermediateTheme)
		
		print(themedPresetString)
	}
	
	private func presetString(for format: PreviewFormat) -> TokenizedString {
		switch format {
		case .swift:
			return [
				TokenizedString.SwiftPresets.structDefinition,
				TokenizedString.SwiftPresets.protocolWithFunctionDefinition,
				TokenizedString.SwiftPresets.literalDeclarations
			].joinedWithDivider()
		case .typescript:
			return [
				TokenizedString.TypeScriptPresets.classDefinition,
				TokenizedString.TypeScriptPresets.typeWithFunctionDefinition,
				TokenizedString.TypeScriptPresets.literalDeclarations
			].joinedWithDivider()
		case .markdown:
			return TokenizedString(tokens: [.word("Not supported.")])
		case .xcode:
			return TokenizedString.XcodePreferencesPresets.preferences
		}
	}
	
}
