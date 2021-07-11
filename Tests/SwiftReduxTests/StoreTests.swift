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
        store.dispatch(action: TestAction.increaseCounter)
        XCTAssertEqual(store.state, TestState(counter: 1))
    }

    func testStoreSendObjectWillChangeWhenStateChanges() {
        let expectation = expectation(description: "should trigger objectWillChange event")
        let store = Store(initialState: TestState(counter: 0), reducer: testReducer)

        store.objectWillChange.sink {
            expectation.fulfill()
        }
        .store(in: &disposeBag)

        store.dispatch(action: TestAction.increaseCounter)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStoreRunsMiddlewareInDispatch() {
        let expectation = expectation(description: "should run middleware in dispatch")
        
        let testMiddleware = Middleware<TestState> { store, next, action in
            expectation.fulfill()
            next(action)
        }
        
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [testMiddleware]
        )
        
        store.dispatch(action: TestAction.increaseCounter)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStoreRunsMiddlewareInSequence() {
        let expectation = expectation(description: "should run middleware in sequence")
        
        let testMiddleware1 = Middleware<TestState> { store, next, action in
            next(action)
        }
        
        let testMiddleware2 = Middleware<TestState> { store, next, action in
            expectation.fulfill()
            next(action)
        }
        
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [testMiddleware1, testMiddleware2]
        )
        
        store.dispatch(action: TestAction.increaseCounter)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStoreCanDispatchThunkAction() {
        let expectation = expectation(description: "store can dispatch thunk")
                
        let thunkAction = ThunkAction<TestState> { store in
            expectation.fulfill()
        }

        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [createThunkMiddleware()]
        )

        store.dispatch(action: thunkAction)
        
        waitForExpectations(timeout: 1)
    }
    
    func testThunkActionWithContextSendsContextWhenAvailable() {
        let expectation = expectation(description: "should run thunk action with context")
                
        class Context { }
        let testContext = Context()
        
        let thunkAction = ThunkAction<TestState>(context: testContext) { store, context in
            XCTAssertTrue(testContext === context)
            expectation.fulfill()
        }

        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [createThunkMiddleware()]
        )

        store.dispatch(action: thunkAction)
        
        waitForExpectations(timeout: 1)
    }
    
    func testSliceStoreReturnsStoreSliceWithCurrentState() {
        let store = Store(
            initialState: TestState(
                counter: 0,
                innerState: InnerState(
                    counter: 5
                )
            ),
            reducer: testReducer
        )
        
        let storeSlice = store.sliceStore(state: \.innerState, actionType: TestAction.self)
        
        XCTAssertEqual(storeSlice.counter, 5)
    }
    
    func testSliceStoreDispatchesActionToStore() {
        let store = Store(
            initialState: TestState(
                counter: 0,
                innerState: InnerState(
                    counter: 0
                )
            ),
            reducer: testReducer
        )
        
        let storeSlice = store.sliceStore(state: \.innerState, actionType: TestAction.self)
        storeSlice.dispatch(action: .increaseInnerCounter)
        
        XCTAssertEqual(storeSlice.counter, 1)
    }
}

private let testReducer = Reducer<TestState> { state, action in
    switch action as? TestAction {
    case .increaseCounter:
        var copyState = state
        copyState.counter = copyState.counter + 1
        return copyState
    case .increaseInnerCounter:
        var copyState = state
        copyState.innerState.counter = copyState.innerState.counter + 1
        return copyState
    case .none:
        return state
    }
}
