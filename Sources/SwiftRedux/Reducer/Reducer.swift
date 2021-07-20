//
//  Reducer.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation

public protocol ReducerType {
    associatedtype State
    associatedtype ActionType
    func callAsFunction(_ state: inout State, _ action: ActionType)
}

public struct Reducer<State, ActionType>: ReducerType where ActionType: Action {
    private let reduce: (_ state: inout State, _ action: ActionType) -> Void
    
    public init(_ reduce: @escaping (_ state: inout State, _ action: ActionType) -> Void) {
        self.reduce = reduce
    }
    
    public func callAsFunction(_ state: inout State, _ action: ActionType) {
        reduce(&state, action)
    }
    
    public func eraseToAnyReducer() -> AnyReducer<State> {
        AnyReducer(self)
    }
}
