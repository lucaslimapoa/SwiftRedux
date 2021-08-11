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
    func testStoreHasInitialState() {
        let store = Store(
            initialState: TestState(counter: 1),
            reducer: TestReducer()
        )
        XCTAssertEqual(store.state, TestState(counter: 1))
    }

    func testStoreHasUpdatedStateWhenActionIsDispatched() {
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: TestReducer()
        )
        store.dispatch(action: TestAction.increaseCounter)
        XCTAssertEqual(store.state, TestState(counter: 1))
    }

    func testStoreSendObjectWillChangeWhenStateChanges() {
        var disposeBag = Set<AnyCancellable>()
        let expectation = expectation(description: "should trigger objectWillChange event")
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: TestReducer()
        )

        store.objectWillChange.sink {
            expectation.fulfill()
        }
        .store(in: &disposeBag)

        store.dispatch(action: TestAction.increaseCounter)

        waitForExpectations(timeout: 0.1)
    }

    func testStoreDoesNotSendObjectWillChangeIfStateIsEqual() {
        var disposeBag = Set<AnyCancellable>()
        let expectation = expectation(description: "should not have duplicate events")
        expectation.isInverted = true
        
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: TestReducer()
        )

        store.objectWillChange.dropFirst().sink {
            expectation.fulfill()
        }
        .store(in: &disposeBag)

        store.dispatch(action: TestAction.increaseCounter)
        store.dispatch(action: TestAction.noop)

        waitForExpectations(timeout: 0.1)
    }
    
    func testStoreRunsMiddlewareInDispatch() {
        let expectation = expectation(description: "should run middleware in dispatch")

        struct TestMiddleware: Middleware {
            let expectation: XCTestExpectation
            
            func run(store: StoreProxy<TestState>, next: (AnyAction) -> Void, action: AnyAction) {
                expectation.fulfill()
                next(action)
            }
        }

        let store = Store(
            initialState: TestState(counter: 0),
            reducer: TestReducer(),
            middleware: TestMiddleware(expectation: expectation)
        )

        store.dispatch(action: TestAction.increaseCounter)

        waitForExpectations(timeout: 0.1)
    }

    func testStoreRunsCombinedMiddleware() {
        let expectation = expectation(description: "should run middleware in sequence")
        expectation.expectedFulfillmentCount = 2

        struct TestMiddleware1: Middleware {
            let expectation: XCTestExpectation
            func run(store: StoreProxy<TestState>, next: (AnyAction) -> Void, action: AnyAction) {
                expectation.fulfill()
                next(action)
            }
        }

        struct TestMiddleware2: Middleware {
            let expectation: XCTestExpectation
            func run(store: StoreProxy<TestState>, next: (AnyAction) -> Void, action: AnyAction) {
                expectation.fulfill()
                next(action)
            }
        }
        
        let store = Store(
            initialState: TestState(counter: 0),
            reducer: TestReducer(),
            middleware: CombinedMiddleware
                .apply(TestMiddleware1(expectation: expectation))
                .apply(TestMiddleware2(expectation: expectation))
        )

        store.dispatch(action: TestAction.increaseCounter)

        waitForExpectations(timeout: 0.1)
    }

    func testStoreCanDispatchThunkAction() {
        let expectation = expectation(description: "store can dispatch thunk")

        let thunk = Thunk<TestState> { store in
            expectation.fulfill()
        }

        let store = Store(
            initialState: TestState(counter: 0),
            reducer: TestReducer(),
            middleware: ThunkMiddleware()
        )

        store.dispatch(action: thunk)

        waitForExpectations(timeout: 0.1)
    }

    func testThunkActionPublisherIsExecuted() {
        let thunkPublisher = ThunkPublisher<TestState> { store in
            Just(TestAction.increaseCounter)
                .eraseToAnyPublisher()
        }

        let store = Store(
            initialState: TestState(counter: 0),
            reducer: TestReducer(),
            middleware: ThunkMiddleware()
        )

        store.dispatch(action: thunkPublisher)

        XCTAssertEqual(store.state, TestState(counter: 1))
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

        enum SubState1Action {
            case increase
        }

        enum SubState2Action {
            case increase
        }

        struct SubState1Reducer: Reducer {
            func reduce(state: inout SubState1, action: SubState1Action) {
                state.counter1 += 1
            }
        }
        
        struct SubState2Reducer: Reducer {
            func reduce(state: inout SubState2, action: SubState2Action) {
                state.counter2 += 1
            }
        }
        
        let store = Store(
            initialState: AppState(),
            reducer: CombinedReducer
                .apply(reducer: SubState1Reducer(), for: \.subState1)
                .apply(reducer: SubState2Reducer(), for: \.subState2)
        )

        store.dispatch(action: SubState1Action.increase)
        store.dispatch(action: SubState2Action.increase)

        XCTAssertEqual(
            store.state,
            AppState(
                subState1: SubState1(counter1: 1),
                subState2: SubState2(counter2: 1)
            )
        )
    }
}

private enum TestAction {
    case increaseCounter
    case increaseInnerCounter
    case noop
}

private struct InnerState: Equatable {
    var counter = 0
}

private struct TestState: Equatable {
    var counter = 0
    var innerState = InnerState()
}

private struct TestReducer: Reducer {
    func reduce(state: inout TestState, action: TestAction) {
        switch action {
        case .increaseCounter:
            state.counter += 1
        case .increaseInnerCounter:
            state.innerState.counter += 1
        case .noop:
            break
        }
    }
}
