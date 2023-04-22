//
//  ValidatorTests.swift
//  Created by bemohansingh on 14/01/2022.
//

import Foundation
@testable import Validator
import XCTest
import Combine

final class ValidatorTests: XCTestCase {
    
    var validator: Validator?
    var cancellable: AnyCancellable?
    
    override func setUp() {
        validator = Validator()
    }
    
    override func tearDown() {
        validator = nil
        cancellable = nil
    }
    
    func testValidableIsBuiltProperly() {
        
        let nameField = TextField()
        let validable = nameField.validable(with: TextInteractor(pattern: Pattern.name, optional: false, emptyMessage: "Please provide name", validationFailedMessage: "Please provide valid name"))
        
        let element = validable.element as? TextField
        XCTAssertNotNil(element)
        XCTAssertTrue(element == nameField)
    }
    
    func testThatInitialValueAddedToTextFieldIsDisplayedInInitialResultTrigger() {
        let expect = expectation(description: "Initial value of TextField is triggered for first result from validation")
        let nameField = TextField()
        nameField.text = "bemohansingh"
        cancellable = validator?
            .validate([nameField.validable(with: TextInteractor(pattern: Pattern.name, optional: false, emptyMessage: "Please provide name", validationFailedMessage: "Please provide valid name"))])
            .sink(receiveValue: { result in
                let firstResult = result.first
                XCTAssertNotNil(firstResult)
                XCTAssertEqual(firstResult?.value, nameField.text)
                XCTAssertTrue(firstResult?.error != nil)
                expect.fulfill()
        })
        
        wait(for: [expect], timeout: 2.0)
    }
    
    func testThatInitialValueAddedToTextViewIsDisplayedInInitialResultTrigger() {
        let expect = expectation(description: "Initial value of TextField is triggered for first result from validation")
        let dataView = TextView()
        dataView.text = "This is some text"
        cancellable = validator?
            .validate([dataView.validable(with: TextInteractor(pattern: Pattern.name, optional: false, emptyMessage: "Please provide data", validationFailedMessage: "Please provide valid data"))])
            .sink(receiveValue: { result in
                let firstResult = result.first
                XCTAssertNotNil(firstResult)
                XCTAssertEqual(firstResult?.value, dataView.text)
                XCTAssertTrue(firstResult?.error != nil)
                expect.fulfill()
        })
        
        wait(for: [expect], timeout: 2.0)
    }
    
}

// MARK: Helpers
final class TextInteractor: Interactor {
    var isOptional: Bool
    
    var pattern: PatternIdentifiable
    
    var emptyMessage: String
    
    var validationFailedMessage: String
    
    init(pattern: PatternIdentifiable, optional: Bool, emptyMessage: String, validationFailedMessage: String) {
        self.isOptional = optional
        self.pattern = pattern
        self.emptyMessage = emptyMessage
        self.validationFailedMessage = validationFailedMessage
    }
}

enum Pattern: PatternIdentifiable {
    case name
    
    var identifier: (expression: String, dataType: String) {
        switch self {
        case .name:
            return ("^.", "name")
        }
    }
}
