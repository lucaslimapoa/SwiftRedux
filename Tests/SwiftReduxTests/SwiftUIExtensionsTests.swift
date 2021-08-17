//
//  SwiftUIExtensionsTests.swift
//
//
//  Created by Lucas Lima on 31.07.21.
//

import Combine
import SwiftUI
@testable import SwiftRedux
import XCTest

// Disabled tests!
// Need to find a way of initilising the Views, so Environment is a valid object.
final class SwiftUIExtensionsTests: XCTestCase {
    func _testUseDispatchEnvironmentDispatchesEventToStore() {
        let expectation = expectation(description: "should dispatch action to store")
        
        struct TestView: View {
            @Dispatch<AnyAction> var dispatch
            init() { }
            var body: some View { EmptyView() }
        }
        
        struct TestReducer: Reducer {
            let reduceSpy: (Action) -> Void
            
            func reduce(state: inout AppState, action: Action) {
                reduceSpy(action)
            }
        }
        
        let reducer = TestReducer { action in
            XCTAssertEqual(action, Action.trigger)
            expectation.fulfill()
        }
        
        let store = Store(initialState: AppState(), reducer: reducer)
        let view = TestView()
        view.store(store)
        
        view.dispatch(action: Action.trigger)
        
        waitForExpectations(timeout: 1)
    }
    
    func _testStoreModifierSetsEnvironmentObjectWithStore() {
        struct TestView: View {
            @EnvironmentObject var store: Store<AppState>
            init() { }
            var body: some View { EmptyView() }
        }
        
        let store = Store(initialState: AppState(), reducer: AppReducer())
        let view = TestView()
        view.store(store)
        
        XCTAssertTrue(view.store === store)
    }
}

private enum Action: Equatable {
    case trigger
}

private struct AppState: Equatable { }

private struct AppReducer: Reducer {
    func reduce(state: inout AppState, action: AnyAction) { }
}
