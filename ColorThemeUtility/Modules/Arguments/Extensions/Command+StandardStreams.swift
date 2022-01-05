//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 04/01/2022.
//

import Foundation
import ArgumentParser

extension ParsableCommand {
	
	/// Reads all lines sent to standard input stream and returns them as a
	/// consecutive string joined with newline characters.
	var linesFromStdin: String? {
		var lines: [String] = []
		
		while let line = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
			guard !line.isEmpty else {
				continue
			}
			
			lines.append(line)
		}
		
		let joinedLines = lines.joined(separator: "\n")
		
		guard !joinedLines.isEmpty else {
			return nil
		}
		
		return joinedLines
	}
	
	var lineFromStdin: String? {
		let line = readLine() ?? ""
		
		guard !line.isEmpty else {
			return nil
		}
		
		return line
	}
	
}
