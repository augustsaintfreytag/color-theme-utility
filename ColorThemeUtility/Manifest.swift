//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/02/2022.
//

import Foundation

/// The application's manifest.
enum Manifest {
	
	// MARK: Data
	
	static let name = "Color Theme Utility"
	static let version = "0.8.2"
	
	// MARK: Formatting
	
	private static var releaseVersionDescription: String { version }
	private static var debugVersionDescription: String { "\(version) Debug Preview" }
	
	static var versionDescription: String {
		#if DEBUG
		return debugVersionDescription
		#else
		return releaseVersionDescription
		#endif
	}
	
}
