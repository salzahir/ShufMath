//
//  ShufMathTests.swift
//  ShufMathTests
//
//  Created by Salman Z on 2/8/25.
//

import Testing
import XCTest
@testable import ShufMath

struct ShufMathTests {
    
    var viewModel = GameViewModel()

    @Test func testSetUpGameDifficulty() async throws {
        
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
        // Arrange
        let expectedDifficulty = GameModel.GameDifficulty.easy

        // Act
        viewModel.safeSetupDiff(difficulty: expectedDifficulty)
        
        // Assert
        XCTAssertNotNil(viewModel.gameDifficulty, "Game Difficulty should not be nil after setup")
        XCTAssertEqual(viewModel.gameDifficulty, expectedDifficulty, "Game difficulty should be set to 'easy'.")

    }
    
    @Test func testGenerateQuestions() {
        
    }

}

