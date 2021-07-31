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

final class SwiftUIExtensionsTests: XCTestCase {
//    func testUseDispatchEnvironmentDispatchesEventToStore() {
//        let expectation = expectation(description: "should dispatch action to store")
//        
//        struct TestView: View {
//            @Environment(\.useDispatch) var dispatch
//            init() { }
//            var body: some View { EmptyView() }
//        }
//        
//        struct TestReducer: Reducer {
//            let reduceSpy: (Action) -> Void
//            
//            func reduce(state: inout AppState, action: Action) {
//                reduceSpy(action)
//            }
//        }
//        
//        let reducer = TestReducer { action in
//            XCTAssertEqual(action, Action.trigger)
//            expectation.fulfill()
//        }
//        
//        let store = Store(initialState: AppState(), reducer: reducer)
//        let view = TestView()
//        view.store(store)
//        
//        view.dispatch(Action.trigger)
//        
//        waitForExpectations(timeout: 1)
//    }
//    func testStoreModifierSetsEnvironmentObjectWithStore() {
//        struct TestView: View {
//            @EnvironmentObject var store: Store<AppState>
//            init() { }
//            var body: some View { EmptyView() }
//        }
//        
//        let store = Store(initialState: AppState(), reducer: AppReducer())
//        let view = TestView()
//        view.store(store)
//        
//        XCTAssertTrue(view.store === store)
//    }
}

private enum Action: Equatable {
    case trigger
}

private struct AppState: Equatable { }

private struct AppReducer: Reducer {
    func reduce(state: inout AppState, action: AnyAction) { }
}
