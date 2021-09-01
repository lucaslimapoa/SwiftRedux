//
//  CombinedReducer.swift
//  
//
//  Created by Lucas Lima on 20.07.21.
//

import Foundation

/**
 A convenience object for combining multiple reducers into one.
 */
public struct CombinedReducer<State>: Reducer {
    private let reduceClosure: (_ state: inout State, _ action: AnyAction) -> Void
    
    public func reduce(state: inout State, action: AnyAction) {
        reduceClosure(&state, action)
    }
    
    /**
     Combines multiple reducers into a single reducer. The reducer will only reduce a single field of a broader state.
     
     - Parameter reducer: A reducer to combine.
     
     - Parameter keyPath: A KeyPath to a single field in the State.
     
     ```
     CombinedReducer<AppState>
         .apply(reducer: SubState1Reducer(), for: \.subState1)
         .apply(reducer: SubState2Reducer(), for: \.subState2)
     ```
     */
    public static func apply<InnerState, R>(reducer: R,
                                            `for` keyPath: WritableKeyPath<State, InnerState>) -> CombinedReducer<State> where R: Reducer, R.State == InnerState {
        CombinedReducer<State> { state, action in
            reducer.reduceAny(state: &state[keyPath: keyPath], action: action)
        }
    }
    
    /**
     Combines multiple reducers into a single reducer. The reducer will only reduce a single field of a broader state.
     
     - Parameter anotherReducer: A reducer to combine.
     
     - Parameter keyPath: A KeyPath to a single field in the State.
     
     ```
     CombinedReducer<AppState>
         .apply(reducer: SubState1Reducer(), for: \.subState1)
         .apply(reducer: SubState2Reducer(), for: \.subState2)
     ```
     */
    public func apply<InnerState, R>(reducer anotherReducer: R,
                                     `for` keyPath: WritableKeyPath<State, InnerState>) -> CombinedReducer<State> where R: Reducer, R.State == InnerState {
        CombinedReducer<State> { [reduce] state, action in
            reduce(&state, action)
            anotherReducer.reduceAny(state: &state[keyPath: keyPath], action: action)
        }
    }
}
