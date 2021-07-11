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
    private let dispatchFunction: DispatchFunction
    
    init(state: @escaping () -> State, dispatch: @escaping (Action) -> Void) {
        self.state = state
        self.dispatchFunction = dispatch
    }
    
    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state()[keyPath: keyPath]
    }
    
    public func dispatch(action: ActionType) {
        dispatchFunction(action)
    }
}
