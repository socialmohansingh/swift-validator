//
//  CombineCollectionTests.swift
//  Created by bemohansingh on 14/01/2022.
//

import Foundation
@testable import Validator
import XCTest
import Combine

final class CombineCollectionTests: XCTestCase {
    
    var cancellable: AnyCancellable?
    
    override func tearDown() {
        cancellable = nil
    }
    
    func testThatCollectionOfPublishersProduceExpectedResults() {
        
        let expect = expectation(description: "The array of publishers are combined properly")
        let name = CurrentValueSubject<String, Never>("bemohansingh")
        let surname = CurrentValueSubject<String, Never>("bemohansingh")
        
        cancellable = [name, surname].combineLatest.map { result -> String in
            let combined = result.joined(separator: " ")
            return combined
        }.eraseToAnyPublisher().sink { value in
            XCTAssertTrue(value == "\(name.value) \(surname.value)")
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 2.0)
    }
}
