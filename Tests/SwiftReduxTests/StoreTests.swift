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
        expectation.expectedFulfillmentCount =  2
        
        let testMiddleware1 = Middleware<TestState> { store, next, action in
            expectation.fulfill()
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
            middleware: [.thunkMiddleware]
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
        
        let scope = store.scope(state: \.innerState)
        
        XCTAssertEqual(scope.state.counter, 5)
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
        
        let scope = store.scope(state: \.innerState)
        scope.dispatch(action: TestAction.increaseInnerCounter)
        
        XCTAssertEqual(scope.state.counter, 1)
    }
    
    func testThunkActionWithStoreSliceIsExecuted() {
        let expectation = expectation(description: "should run thunk action in Store")
        
        let thunkAction = ThunkAction<InnerState> { _ in
            expectation.fulfill()
        }

        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [.thunkMiddleware]
        )

        let scope = store.scope(state: \.innerState)
        scope.dispatch(action: thunkAction)
        
        waitForExpectations(timeout: 1)
    }
    
    func testThunkActionPublisherIsExecuted() {
        let thunkPublisher = ThunkActionPublisher<TestState> { store in
            Just(TestAction.increaseCounter)
                .eraseToAnyPublisher()
        }
        
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [.thunkMiddleware]
        )
        
        store.dispatch(action: thunkPublisher)
        
        XCTAssertEqual(store.state, TestState(counter: 1))
    }
    
    func testThunkActionPublisherWithStoreSliceIsExecuted() {
        let expectation = expectation(description: "should run thunk action publisher in Store")
        
        let thunkAction = ThunkActionPublisher<InnerState> { _ in
            expectation.fulfill()
            return Empty<Action, Never>(completeImmediately: true)
                .eraseToAnyPublisher()
        }

        let store = Store(
            initialState: TestState(counter: 0),
            reducer: testReducer,
            middleware: [.thunkMiddleware]
        )

        let scope = store.scope(state: \.innerState)
        scope.dispatch(action: thunkAction)
        
        waitForExpectations(timeout: 1)
    }
    
    func testCombineReducersUpdatesOnlyStateFromAGivenReducer() {
        struct AppState: Equatable {
            var subState1 = SubState1()
            var subState2 = SubState2()
        }
        
        struct SubState1: Equatable {
            var counter1 = 0
        }
        
        struct SubState2: Equatable {
            var counter2 = 0
        }
        
        enum SubState1Action: Action {
            case increase
        }
        
        enum SubState2Action: Action {
            case increase
        }
        
        let subState1Reducer = Reducer<SubState1> { state, action in
            switch action as? SubState1Action {
            case .increase:
                state.counter1 += 1
            case .none:
                break
            }
        }
        
        let subState2Reducer = Reducer<SubState2> { state, action in
            switch action as? SubState2Action {
            case .increase:
                state.counter2 += 1
            case .none:
                break
            }
        }
        
        let store = Store(
            initialState: AppState(),
            reducer: Reducer<AppState>
                .apply(reducer: subState1Reducer, for: \.subState1)
                .apply(reducer: subState2Reducer, for: \.subState2)
        )
        
        store.dispatch(action: SubState1Action.increase)
        
        XCTAssertEqual(store.state, AppState(subState1: SubState1(counter1: 1)))
    }
}

private enum TestAction: Action {
    case increaseCounter
    case increaseInnerCounter
}

private struct InnerState: Equatable {
    var counter = 0
}

private struct TestState: Equatable {
    var counter = 0
    var innerState = InnerState()
}

private let testReducer = Reducer<TestState> { state, action in
    switch action as? TestAction {
    case .increaseCounter:
        state.counter += 1
    case .increaseInnerCounter:
        state.innerState.counter += 1
    case .none:
        break
    }
}
