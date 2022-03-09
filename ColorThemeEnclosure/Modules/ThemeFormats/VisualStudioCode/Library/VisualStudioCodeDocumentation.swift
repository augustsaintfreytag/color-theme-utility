//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 17/02/2022.
//

import Foundation

private let template = """
# %@ Theme

%@

This color theme was generated with the Color Theme Utility
([gitlab.com/apricum/color-theme-utility](https://gitlab.com/apricum/color-theme-utility)),
developed by August Saint Freytag ([augustfreytag.com](https://augustfreytag.com)).
The utility creates rich color themes in multiple formats from a set of ten base colors
expanded to individual tones for declarations, types, functions, literals, and other elements.
"""

func readmeTextForVisualStudioCodeTheme(name: String, description: String?) -> String {
	return String(format: template, arguments: [name, description ?? "(No description)"])
}
