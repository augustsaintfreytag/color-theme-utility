//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 12/02/2022.
//

import Foundation

extension String {
	
	// MARK: Range
	
	public var fullRange: Range<String.Index> {
		startIndex ..< endIndex
	}
	
	private var fullMatchingRange: NSRange {
		NSRange(fullRange, in: self)
	}
	
	// MARK: Pattern In
	
	/// Returns a match of the string against the given regular expression pattern.
	public func matches(_ pattern: String, expressionOptions: NSRegularExpression.Options = [], matchingOptions: NSRegularExpression.MatchingOptions = []) throws -> Bool {
		let expression = try NSRegularExpression(pattern: pattern, options: expressionOptions)
		return expression.firstMatch(in: self, options: matchingOptions, range: fullMatchingRange) != nil
	}
	
	/// Matches the string against the given regular expression pattern using the defined matching
	/// options and replaces each match with the given template and returns the resulting string.
	public func replacingMatches(matching pattern: String, expressionOptions: NSRegularExpression.Options = [], matchingOptions: NSRegularExpression.MatchingOptions = [], with template: String) throws -> String {
		let expression = try NSRegularExpression(pattern: pattern, options: expressionOptions)
		return replacingMatches(matching: expression, options: matchingOptions, with: template)
	}
	
	/// Matches the string against the given regular expression pattern using the defined matching
	/// options and returns a string with each match removed.
	public func removingMatches(matching pattern: String, expressionOptions: NSRegularExpression.Options = [], matchingOptions: NSRegularExpression.MatchingOptions = []) throws -> String {
		let expression = try NSRegularExpression(pattern: pattern, options: expressionOptions)
		return removingMatches(matching: expression, options: matchingOptions)
	}
	
	// MARK: Expression In
	
	/// Returns a match of the string against the given regular expression.
	public func matches(_ expression: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
		return expression.firstMatch(in: self, options: options, range: fullMatchingRange) != nil
	}
	
	/// Matches the string against the given regular expression using the defined matching
	/// options and replaces each match with the given template and returns the resulting string.
	public func replacingMatches(matching expression: NSRegularExpression, options: NSRegularExpression.MatchingOptions = [], with template: String) -> String {
		let mutableString = NSMutableString(string: self)
		let range = NSRange(location: 0, length: mutableString.length)
		
		expression.replaceMatches(in: mutableString, options: options, range: range, withTemplate: template)
		
		return String(mutableString)
	}
	
	/// Matches the string against the given regular expression using the defined matching
	/// options and returns a string with each match removed.
	public func removingMatches(matching expression: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> String {
		return replacingMatches(matching: expression, options: options, with: "")
	}
	
}
