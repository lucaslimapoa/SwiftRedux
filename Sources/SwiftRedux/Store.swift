//
//  Store.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation
import SwiftUI

public final class Store<State, Action>: ObservableObject {
    @Published public private(set) var state: State
    private let reducer: Reducer<State, Action>
    private var dispatchWithMiddleware: DispatchFunction<Action>!
    
    public init(initialState: State, reducer: Reducer<State, Action>, middleware: [Middleware<State, Action>] = []) {
        self.state = initialState
        self.reducer = reducer
        self.dispatchWithMiddleware = Self.applyMiddleware(middleware, store: ({ [unowned self] in self.state }, storeDispatch))
    }
    
    private static func applyMiddleware<State>(_ middleware: [Middleware<State, Action>], store: StoreAPI<State, Action>) -> (Action) -> Void {
        middleware.reversed()
            .reduce({ action in store.dispatch(action) }) { current, next in
                next(store)(current)
            }
    }
        
    private func storeDispatch(action: Action) {
        state = reducer(state, action)
    }
    
    public func dispatch(action: Action) {
        guard Thread.isMainThread else { fatalError("The dispatch(action:) function must be used from the Main Thread") }
        dispatchWithMiddleware(action)
    }
}
