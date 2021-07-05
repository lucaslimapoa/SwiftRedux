//
//  Reducer.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation

public typealias AnyAction = Any

public struct Reducer<State, Action>  {
    private let reduce: (State, Action) -> State
    
    public init(_ reduce: @escaping (State, Action) -> State) {
        self.reduce = reduce
    }
    
    public func callAsFunction(_ state: State, _ action: Action) -> State {
        reduce(state, action)
    }
    
    public func callAsFunction(_ state: State, _ action: AnyAction) -> State {
        guard let action = action as? Action else { return state }
        return reduce(state, action)
    }
}
