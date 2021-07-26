//
//  Reducer.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation

public protocol Reducer {
    associatedtype State
    associatedtype ActionType
    
    func reduce(state: inout State, action: ActionType)
}

extension Reducer {
    func reduceAny(state: inout State, action: AnyAction) {
        guard let action = action as? ActionType else { return }
        reduce(state: &state, action: action)
    }
}
