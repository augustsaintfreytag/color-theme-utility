//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 12/01/2022.
//

import Foundation
import ColorThemeModelingFramework

/// The main color theme module, optimized for WebAssembly.
///
/// This module is built as a strict subset of the greater `ColorThemeUtility` target,
/// offering only functionality needed in an external integration version of the utility.
///
/// The module includes the following feature set:
///
/// - Color format detection (color in, description out)
/// - Color format conversion (color in, color out)
/// - Theme generation (colors in, intermediate theme out)
///
struct Module: IntermediateThemeModeler {}
