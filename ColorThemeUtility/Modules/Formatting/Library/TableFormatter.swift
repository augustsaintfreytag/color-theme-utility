//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/10/2021.
//

import Foundation

public protocol TableFormatter {}

extension TableFormatter {
	
	// MARK: Configuration
	
	private static var columnPadding: Int { 4 }
	private static var space: Character { " " }
	private static var divider: Character { "─" }
	
	static var dividerRow: [String] { [repeatedString(divider, count: 30)] }
	
	// MARK: Formatting
	
	public static func tabulateAndPrintLines(_ rows: [[String]]) {
		tabulatedLines(rows).forEach { line in print(line) }
	}
	
	public static func tabulatedLines(_ rows: [[String]]) -> [String] {
		return tabulatedRows(rows).map { row in
			return row.joined(separator: String(space))
		}
	}
	
	public static func tabulatedRows(_ rows: [[String]]) -> [[String]] {
		let numberOfColumns = numberOfColumns(in: rows)
		var formattedRows = rows.map { columns -> [String] in [] }
		
		for columnIndex in 0 ..< numberOfColumns {
			let maxColumnLength = maxNumberOfCharacters(rows, in: columnIndex) ?? 0
			
			for rowIndex in 0 ..< rows.count {
				guard columnIndex < rows[rowIndex].count else {
					continue
				}
						
				let formattedColumn = tabulatedColumn(rows[rowIndex][columnIndex], toLength: maxColumnLength)
				formattedRows[rowIndex].append(formattedColumn)
			}
		}
		
		return formattedRows
	}
	
	private static func tabulatedColumn(_ column: String, toLength length: Int) -> String {
		let baseLength = column.count
		let paddingLength = length + columnPadding - baseLength
		
		guard paddingLength >= 0 else {
			assertionFailure("Formatting inconsistency error. Can not format line (\(column.count)) longer than expected padding length \(length).")
			return column
		}
		
		let paddingSpaces = String(repeating: space, count: paddingLength)
		return column + paddingSpaces
	}
	
	// MARK: Analysis
	
	private static func numberOfColumns(in rows: [[String]]) -> Int {
		let numberOfColumnsPerRow = rows.map { columns -> Int in
			return columns.count
		}.sorted()
		
		return numberOfColumnsPerRow.last ?? 0
	}
	
	private static func maxNumberOfCharacters(_ rows: [[String]], in columnIndex: Int) -> Int? {
		let numberOfCharactersPerColumn = rows.map { columns -> String in
			guard columnIndex < columns.count else {
				return ""
			}
			
			return columns[columnIndex]
		}.map { column -> Int in
			column.count
		}.sorted()
		
		return numberOfCharactersPerColumn.last
	}
	
	private static func repeatedString(_ character: Character, count: Int) -> String {
		let chain = (0 ..< count).map { _ in character }
		return String(chain)
	}
	
	// MARK: Truncation
	
	private static var maxNumberOfCharactersBeforeTruncation: Int { 48 }
	
	public static func truncatedString(_ value: String) -> String {
		guard value.count > maxNumberOfCharactersBeforeTruncation else {
			return value
		}
		
		let truncatedString = value.prefix(maxNumberOfCharactersBeforeTruncation)
		return truncatedString + "…"
	}
	
}
