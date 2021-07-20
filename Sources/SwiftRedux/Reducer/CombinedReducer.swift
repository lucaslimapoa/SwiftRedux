//
//  CombineReducers.swift
//  
//
//  Created by Lucas Lima on 20.07.21.
//

import Foundation

public struct CombinedReducer<State>: ReducerType {
    private let reduce: (_ state: inout State, _ action: Action) -> Void
    
    init<R>(_ reduce: R) where R: ReducerType, R.State == State {
        self.reduce = { state, action in
            guard let action = action as? R.ActionType else { return }
            reduce(&state, action)
        }
    }
    
    init(_ reduce: @escaping (_ state: inout State, _ action: Action) -> Void) {
        self.reduce = reduce
    }
    
    public func callAsFunction(_ state: inout State, _ action: Action) {
        reduce(&state, action)
    }
    
    public func apply<InnerState, R>(reducer anotherReducer: R,
                                     `for` keyPath: WritableKeyPath<State, InnerState>) -> CombinedReducer<State> where R: ReducerType, R.State == InnerState {
        CombinedReducer<State> { [reduce] state, action in
            reduce(&state, action)
            if let action = action as? R.ActionType {
                anotherReducer(&state[keyPath: keyPath], action)
            }
        }
    }
    
    public static func apply<InnerState, R>(reducer: R,
                                            `for` keyPath: WritableKeyPath<State, InnerState>) -> CombinedReducer<State> where R: ReducerType, R.State == InnerState {
        CombinedReducer<State> { state, action in
            guard let action = action as? R.ActionType else { return }
            reducer(&state[keyPath: keyPath], action)
        }
    }
}
