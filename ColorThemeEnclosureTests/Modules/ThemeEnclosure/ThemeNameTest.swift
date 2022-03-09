//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 08/03/2022.
//

import XCTest
@testable import ColorThemeEnclosure

class ThemeNameTest: XCTestCase {
	
	private class Module: ThemeNameProvider {}
	
	func testThemeNameSanitizationWithAllowedName() {
		let names: [String] = [
			"Theme",
			"Theme with Space",
			"Theme (Name)",
			"Theme @Home",
			"#ThemeStudio",
			"Art + Style"
		]
		
		for name in names {
			XCTAssertEqual(Module.sanitizedThemeName(name), name)
		}
	}
	
	func testThemeNameSanitizationWithAllowedSpecialCharacters() {
		let names: [String] = [
			"Punctuate, punctuate.",
			"TL;DR",
			"Amper & Sands"
		]
		
		for name in names {
			XCTAssertEqual(Module.sanitizedThemeName(name), name)
		}
	}
	
	func testThemeNameSanitizationWithNonAsciiAlphabets() {
		let names: [String] = [
			"Latin Theme",
			"Neue Bücherei",
			"Récits de Grèves Stressantes",
			"Spalvų paroda"
		]
		
		for name in names {
			XCTAssertEqual(Module.sanitizedThemeName(name), name)
		}
	}
	
	func testThemeNameSanitizationTrimming() {
		let names: [(input: String, output: String)] = [
			("Name ", "Name"),
			(" Name ", "Name"),
			("  Sand  &  Ember  ", "Sand & Ember"),
			("\t\tName\n\n", "Name")
		]
		
		for (inputName, expectedName) in names {
			XCTAssertEqual(Module.sanitizedThemeName(inputName), expectedName)
		}
	}
	
	func testThemeNameSanitizationWithDisallowedSpecialCharacters() {
		let names: [(input: String, output: String)] = [
			("Colon: Name", "Colon Name"),
			("Windows \\ / : * ? \" < > |", "Windows"),
			("Mac : /", "Mac"),
			("Set %¡™£¢∞§¶•ªº–≠±⁄€‹›ﬁﬂ‡°·‚—±", "Set")
		]
		
		for (inputName, expectedName) in names {
			XCTAssertEqual(Module.sanitizedThemeName(inputName), expectedName)
		}
	}
	
}
