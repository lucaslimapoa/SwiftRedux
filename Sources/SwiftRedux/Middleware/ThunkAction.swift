//
//  ThunkAction.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

public struct ThunkAction<State>: Action {
    private let thunk: (StoreAPI<State>) -> Void
    
    public init(_ thunk: @escaping (StoreAPI<State>) -> Void) {
        self.thunk = thunk
    }
    
    public init<Context>(context: @escaping @autoclosure () -> Context, _ thunk: @escaping (StoreAPI<State>, Context) -> Void) {
        self.thunk = { store in
            thunk(store, context())
        }
    }
    
    public func callAsFunction(_ store: StoreAPI<State>) {
        thunk(store)
    }
}
