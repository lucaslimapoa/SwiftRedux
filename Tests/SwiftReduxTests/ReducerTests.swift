//
//  ReducerTests.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import SwiftRedux
import Combine
import XCTest

final class ReducerTests: XCTestCase {
    func testReducerReturnsUpdatedState() {
        let testReducer = Reducer<TestState> { state, action in
            state.counter = 0
        }
        
        var state = TestState(counter: -1)
        testReducer(&state, TestAction.increaseCounter)
        
        XCTAssertEqual(state, TestState(counter: 0))
    }
}
