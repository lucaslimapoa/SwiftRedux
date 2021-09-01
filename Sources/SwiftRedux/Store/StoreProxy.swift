//
//  StoreProxy.swift
//
//
//  Created by Lucas Lima on 26.07.21.
//

import Foundation

public final class StoreProxy<State>: Storable {
    private let dispatch: DispatchFunction<AnyAction>
    private let getState: () -> State
    
    /**
     A readonly getter for the current state in the store.
     */
    public var state: State {
        getState()
    }
    
    /**
     Creates a StoreProxy from a Store object. Used for managing memory to the original store.
     
     - Parameter store: An store to create a proxy to.
     
     ```
     let proxy = StoreProxy(
        store: Store(
            initialState: AppState(),
            reducer: Reducer()
        )
     )
     ```
     */
    init<T>(store: T) where T: Storable, T.State == State {
        self.getState = { [unowned store] in
            store.state
        }
        
        self.dispatch = { [unowned store] action in
            store.dispatch(action: action)
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
        dispatch(action)
    }
}
