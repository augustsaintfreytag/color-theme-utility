//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/10/2021.
//

import Foundation

/// A theme of a fixed collection of color values, used for a specific domain or for exchange.
public protocol Theme {}

extension Theme where Self: Encodable {
	
	/// A pretty-printed description of the encoded theme contents for
	/// debugging or outputting to streams.
	public var formattedEncodedDescription: String? {
		let debugPrintEncoder = JSONEncoder()
		debugPrintEncoder.outputFormatting = [.sortedKeys, .prettyPrinted]
		
		guard
			let data = try? debugPrintEncoder.encode(self),
			let string = String(data: data, encoding: .utf8)
		else {
			return nil
		}
		
		return string
	}
	
}
