//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 26/11/2021.
//

import Foundation

/// Detection functionality to determine the terminal the utility is currently running in.
public protocol TerminalDetector {}

extension TerminalDetector {

	private static var terminalEnvironmentKey: String { "TERM_PROGRAM" }

	public static var terminalApplication: TerminalApplication? {
		guard let terminalDescription = ProcessInfo.processInfo.environment[terminalEnvironmentKey]?.lowercased() else {
			return nil
		}

		if terminalDescription.contains("iterm") {
			return .iterm
		}

		if terminalDescription.contains("apple_terminal") {
			return .apple
		}

		return nil
	}

}
