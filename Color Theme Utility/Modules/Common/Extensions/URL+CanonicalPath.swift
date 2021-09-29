//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

extension URL {
	
	init?(fileURLWithNonCanonicalPath path: String) {
		guard let canonicalPath = Self.resolvedCanonicalPath(from: path) else {
			return nil
		}
		
		self.init(fileURLWithPath: canonicalPath)
	}
	
	// MARK: Path Resolve
	
	private static var rootUrl: URL {
		return URL(string: "/")!
	}
	
	private static var currentUserHomeDirectoryUrl: URL {
		return FileManager.default.homeDirectoryForCurrentUser
	}
	
	private static func resolvedCanonicalPath(from path: String) -> String? {
		let resolvableUrl = Self.resolvedURLFromPathWithHomeDirectory(from: path)
		
		do {
			let resolvableUrlResourceValues = try resolvableUrl.resourceValues(forKeys: [.canonicalPathKey])
			let canonicalPath = resolvableUrlResourceValues.canonicalPath
			
			return canonicalPath
		} catch {
			print("Could not resolve canonical path for input '\(path)'. \(error.localizedDescription)")
			return nil
		}
	}
	
	private static func resolvedURLFromPathWithHomeDirectory(from path: String) -> URL {
		guard !path.hasPrefix("~") else {
			let trimmedPath = path.replacingOccurrences(of: "~/", with: "")
			return URL(fileURLWithPath: trimmedPath, relativeTo: currentUserHomeDirectoryUrl)
		}
		
		return URL(fileURLWithPath: path, relativeTo: nil)
	}
	
}
