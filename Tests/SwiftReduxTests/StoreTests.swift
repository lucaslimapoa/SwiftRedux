//
//  StoreTests.swift
//
//
//  Created by Lucas Lima on 01.07.21.
//

@testable import SwiftRedux
import Combine
import XCTest

final class StoreTests: XCTestCase {
    var disposeBag = Set<AnyCancellable>()
    
    func testStoreHasInitialState() {
        let store = Store(initialState: TestState(counter: 1), reducer: testReducer)
        XCTAssertEqual(store.state, TestState(counter: 1))
    }

    func testStoreHasUpdatedStateWhenActionIsDispatched() {
        let store = Store(initialState: TestState(counter: 0), reducer: testReducer)
        store.dispatch(action: .increaseCounter)
        XCTAssertEqual(store.state, TestState(counter: 1))
    }

    func testStoreSendObjectWillChangeWhenStateChanges() {
        let expectation = expectation(description: "should trigger objectWillChange event")
        let store = Store(initialState: TestState(counter: 0), reducer: testReducer)

        store.objectWillChange.sink {
            expectation.fulfill()
        }
        .store(in: &disposeBag)

        store.dispatch(action: .increaseCounter)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStoreRunsMiddlewareInDispatch() {
        let expectation = expectation(description: "should run middleware in dispatch")
        
        let testMiddleware = Middleware<TestState, TestAction> { store, next, action in
            expectation.fulfill()
            next(action)
        }
        
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [testMiddleware]
        )
        
        store.dispatch(action: .increaseCounter)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStoreRunsMiddlewareInSequence() {
        let expectation = expectation(description: "should run middleware in sequence")
        
        let testMiddleware1 = Middleware<TestState, TestAction> { store, next, action in
            next(action)
        }
        
        let testMiddleware2 = Middleware<TestState, TestAction> { store, next, action in
            expectation.fulfill()
            next(action)
        }
        
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [testMiddleware1, testMiddleware2]
        )
        
        store.dispatch(action: .increaseCounter)
        
        waitForExpectations(timeout: 1)
    }
}

struct TestState: Equatable {
    var counter = 0
}

enum TestAction {
    case increaseCounter
}

let testReducer = Reducer<TestState, TestAction> { state, action in
    switch action {
    case .increaseCounter:
        var copyState = state
        copyState.counter = copyState.counter + 1
        return copyState
    }
}
