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
    
    public func combine<InnerState, R>(subState keyPath: WritableKeyPath<State, InnerState>,
                                       reducer anotherReducer: R) -> Reducer where R: ReducerType, R.State == InnerState {
        Reducer { [reduce] state, action in
            reduce(&state, action)
            anotherReducer(&state[keyPath: keyPath], action)
        }
    }
    
    public static func combine<InnerState, R>(subState keyPath: WritableKeyPath<State, InnerState>,
                                              reducer: R) -> Reducer where R: ReducerType, R.State == InnerState {
        Reducer { state, action in
            reducer(&state[keyPath: keyPath], action)
        }
    }
}
