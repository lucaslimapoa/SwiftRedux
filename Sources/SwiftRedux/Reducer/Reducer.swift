//
//  Reducer.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation

public protocol ReducerType {
    associatedtype State
    func callAsFunction(_ state: inout State, _ action: Action)
}

public struct Reducer<State>: ReducerType {    
    private let reduce: ReducerFunction<State>
    
    public init(_ reduce: @escaping ReducerFunction<State>) {
        self.reduce = reduce
    }
    
    public func callAsFunction(_ state: inout State, _ action: Action) {
        reduce(&state, action)
    }
    
    public func apply<InnerState, R>(reducer anotherReducer: R,
                                     `for` keyPath: WritableKeyPath<State, InnerState>) -> Reducer where R: ReducerType, R.State == InnerState {
        Reducer { [reduce] state, action in
            reduce(&state, action)
            anotherReducer(&state[keyPath: keyPath], action)
        }
    }
    
    public static func apply<InnerState, R>(reducer: R,
                                              `for` keyPath: WritableKeyPath<State, InnerState>) -> Reducer where R: ReducerType, R.State == InnerState {
        Reducer { state, action in
            reducer(&state[keyPath: keyPath], action)
        }
    }
}
