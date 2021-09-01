//
//  Store.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation
import Combine

public final class Store<State>: ObservableObject where State: Equatable {
    /**
     A readonly getter for the current state in the store.
     */
    public private(set) var state: State {
        willSet {
            guard newValue != state else { return }
            objectWillChange.send()
        }
    }
    
    private var dispatchWithMiddleware: DispatchFunction<AnyAction>!

    /**
     Creates a Store without middleware.
     - Parameter initialState: The initial state to initialize the store with. State object must be Equatable.
     
     - Parameter reducer: The reducer that will handle actions sent to the store.
     If reducer composition is needed, use CombinedReducer, and assign each reducer its own field within the State.
     
     ```
     let store = Store(
        initialState: AppState(),
        reducer: CombinedReducer
            .apply(reducer: Reducer(), for: \.field)
     )
     ```
    */
    public convenience init<R>(initialState: State, reducer: R) where R: Reducer, R.State == State {
        self.init(initialState: initialState, reducer: reducer, middleware: NoOpMiddleware())
    }

    /**
     Creates a Store with middleware.
     - Parameter initialState: The initial state to initialize the store with. State object must be Equatable.
     
     - Parameter reducer: The reducer that will handle actions sent to the store.
     If reducer composition is needed, use CombinedReducer, and assign each reducer its own field within the State.
     
     - Parameter middleware: All actions are going to be passed through the middleware, for adding behavior to the store.
     
     ```
     let store = Store(
        initialState: AppState(),
        reducer: CombinedReducer
            .apply(reducer: Reducer(), for: \.field),
        middleware: CombinedMiddleware
            .apply(ThunkMiddleware())
            .apply(AnotherMiddleware())
     )
     ```
    */
    public init<R, M>(initialState: State, reducer: R, middleware: M) where R: Reducer, R.State == State, M: Middleware, M.State == State {
        self.state = initialState
        let storeProxy = StoreProxy(store: self)
        self.dispatchWithMiddleware = { action in
            middleware.run(
                store: storeProxy,
                next: { reducer.reduceAny(state: &self.state, action: $0) },
                action: action
            )
        }
    }
    
    /**
     Dispatches actions to the store. Each action is first sent through the Middleware, then to the reducer.
     The middleware can short circuit actions if needed.
     
     - Parameter action: An action to be handled by the middleware and reducer.
     
     ```
     store.dispatch(action: CounterAction.increase)
     ```
    */
    public func dispatch<Action>(action: Action) {
        dispatchWithMiddleware(action)
    }
}

extension Store: Storable { }
