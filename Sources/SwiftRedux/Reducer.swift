//
//  Reducer.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation

public struct Reducer<State> {
    private let reduce: (State, Action) -> State
    
    public init(_ reduce: @escaping (State, Action) -> State) {
        self.reduce = reduce
    }
    
    public func callAsFunction(_ state: State, _ action: Action) -> State {
        reduce(state, action)
    }
    
    public func callAsFunction<T>(_ state: State, _ action: T) -> State where T: Action {
        reduce(state, action as T)
    }
}
