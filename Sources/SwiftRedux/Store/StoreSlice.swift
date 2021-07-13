//
//  StoreSlice.swift
//  
//
//  Created by Lucas Lima on 11.07.21.
//

import Foundation

@dynamicMemberLookup
public final class StoreSlice<State, ActionType> where ActionType: Action {
    private let state: () -> State
    private let dispatchWithMiddleware: CombinedMiddleware
    
    init(storeAPI: StoreAPI<State>) {
        self.state = storeAPI.state
        self.dispatchWithMiddleware = CombinedMiddleware([createThunkMiddleware()], store: storeAPI)
    }
    
    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state()[keyPath: keyPath]
    }
    
    public func dispatch(action: ActionType) {
        dispatchWithMiddleware(action: action)
    }
    
    public func dispatch(action thunk: ThunkAction<State>) {
        dispatchWithMiddleware(action: thunk as Action)
    }
}
