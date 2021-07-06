//
//  File.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

public struct ThunkAction<State>: Action {
    private let thunk: (StoreAPI<State>) -> Void
    
    init(_ thunk: @escaping (StoreAPI<State>) -> Void) {
        self.thunk = thunk
    }
    
    public func callAsFunction(_ store: StoreAPI<State>) {
        thunk(store)
    }
}
