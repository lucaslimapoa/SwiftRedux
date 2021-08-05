//
//  Store.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation
import Combine

public final class Store<State>: ObservableObject where State: Equatable {
    public private(set) var state: State {
        willSet {
            guard newValue != state else { return }
            objectWillChange.send()
        }
    }
    
    private var dispatchWithMiddleware: DispatchFunction<AnyAction>!

    public convenience init<R>(initialState: State, reducer: R) where R: Reducer, R.State == State {
        self.init(initialState: initialState, reducer: reducer, middleware: NoOpMiddleware())
    }
    
    public init<R, M>(initialState: State, reducer: R, middleware: M) where R: Reducer, R.State == State, M: Middleware, M.State == State {
        self.state = initialState
        let storeProxy = StoreProxy(store: self)
        self.dispatchWithMiddleware = { action in
            middleware.run(store: storeProxy, action: action)
            reducer.reduceAny(state: &self.state, action: action)
        }
    }
    
    public func dispatch<Action>(action: Action) {
        dispatchWithMiddleware(action)
    }
}

extension Store: Storable { }
