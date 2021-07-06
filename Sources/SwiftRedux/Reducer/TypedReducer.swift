//
//  TypedReducer.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

public struct TypedReducer<State, ActionType> where ActionType: Action {
    private let reduce: (State, ActionType) -> State
    
    public init(_ reduce: @escaping (State, ActionType) -> State) {
        self.reduce = reduce
    }
    
    public func callAsFunction(_ state: State, _ action: Action) -> State {
        guard let action = action as? ActionType else { return state }
        return reduce(state, action)
    }
}
