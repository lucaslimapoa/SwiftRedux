//
//  CombinedMiddlewareTests.swift
//
//
//  Created by Lucas Lima on 26.07.21.
//

import Foundation

@testable import SwiftRedux
import Combine
import XCTest

final class CombinedMiddlewareTests: XCTestCase {
    func testMiddlewareIsInvokedInSequence() {
        let expectation = expectation(description: "should call middleware in sequence")
        expectation.expectedFulfillmentCount = 3
        
        struct TestMiddleware: Middleware {
            let afterRun: () -> Void
            func run(store: StoreProxy<TestState>, next: (AnyAction) -> Void, action: AnyAction) {
                afterRun()
                next(action)
            }
        }

        var middleware1Called = false
        
        let middleware1 = TestMiddleware {
            middleware1Called = true
            expectation.fulfill()
        }
        
        let middleware2 = TestMiddleware {
            XCTAssertTrue(middleware1Called)
            expectation.fulfill()
        }
        
        let sut = CombinedMiddleware<TestState>
            .apply(middleware1)
            .apply(middleware2)

        sut.run(
            store: StoreProxy<TestState>(store: StoreMock()),
            next: { _ in
                expectation.fulfill()
            },
            action: TestAction.someAction
        )
        
        waitForExpectations(timeout: 0.1)
    }
}

private final class StoreMock: Storable {
    var state = TestState()
    func dispatch<Action>(action: Action) { }
}

private struct TestState { }

private enum TestAction {
    case someAction
}

private struct TestReducer: Reducer {
    func reduce(state: inout TestState, action: TestAction) { }
}
