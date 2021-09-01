//
//  Reducer.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation
/**
 A protocol that all reducers must conform to.
 A reducer is an object that changes the state based on the action received.
 */
public protocol Reducer {
    associatedtype State
    associatedtype ActionType
    
    /**
     Updates the state based on the action received.
     
     - Parameter state: An inout state, to be changed based on the action.
     
     - Parameter action: The action containing the information necessary to change the state.
     
     ```
     struct CounterReducer: Reducer {
         func reduce(state: inout CountState, action: CountAction) {
             switch action {
             case .increase:
                 state.counter += 1
             case .decrease:
                 state.counter -= 1
             }
         }
     }
     ```
     */
    func reduce(state: inout State, action: ActionType)
}

extension Reducer {
    func reduceAny(state: inout State, action: AnyAction) {
        guard let action = action as? ActionType else { return }
        reduce(state: &state, action: action)
    }
}
