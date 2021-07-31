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
    
    public var state: State {
        getState()
    }
    
    init<T>(store: T) where T: Storable, T.State == State {
        self.getState = { [unowned store] in
            store.state
        }
        
        self.dispatch = { [unowned store] action in
            store.dispatch(action: action)
        }
    }
    
    public func dispatch<Action>(action: Action) {
        dispatch(action)
    }
}
