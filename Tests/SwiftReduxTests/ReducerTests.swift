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
    func testTypedReducerReturnsUnchangedStateWhenActionNotAccepted() {
        let testReducer = TypedReducer<TestState, TestAction> { state, action in
            TestState(counter: 0)
        }
        
        let previousState = TestState(counter: -1)
        let nextState = testReducer(previousState, UnsupportedAction.increaseCounter)
        
        XCTAssertEqual(previousState, nextState)
    }
    
    func testTypedReducerReturnsStateWhenActionAccepted() {
        let testReducer = TypedReducer<TestState, TestAction> { state, action in
            TestState(counter: 0)
        }
        
        let previousState = TestState(counter: -1)
        let nextState = testReducer(previousState, TestAction.increaseCounter)
        
        XCTAssertEqual(nextState, TestState(counter: 0))
    }
}

enum UnsupportedAction: Action {
    case increaseCounter
}
