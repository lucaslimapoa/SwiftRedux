//
//  CombinedReducer.swift
//  
//
//  Created by Lucas Lima on 20.07.21.
//

import Foundation

public struct CombinedReducer<State>: Reducer {
    private let reduceClosure: (_ state: inout State, _ action: AnyAction) -> Void
    
    public func reduce(state: inout State, action: AnyAction) {
        reduceClosure(&state, action)
    }
    
    public static func apply<InnerState, R>(reducer: R,
                                            `for` keyPath: WritableKeyPath<State, InnerState>) -> CombinedReducer<State> where R: Reducer, R.State == InnerState {
        CombinedReducer<State> { state, action in
            reducer.tryReduce(state: &state[keyPath: keyPath], action: action)
        }
    }
    
    public func apply<InnerState, R>(reducer anotherReducer: R,
                                     `for` keyPath: WritableKeyPath<State, InnerState>) -> CombinedReducer<State> where R: Reducer, R.State == InnerState {
        CombinedReducer<State> { [reduce] state, action in
            reduce(&state, action)
            anotherReducer.tryReduce(state: &state[keyPath: keyPath], action: action)
        }
    }
}
