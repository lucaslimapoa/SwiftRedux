//
//  ThunkAction.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

public struct Thunk<RootState> {
    private let thunk: (StoreAPI<RootState>) -> Void
    
    public init(_ thunk: @escaping (StoreAPI<RootState>) -> Void) {
        self.thunk = thunk
    }
    
    public func callAsFunction(_ store: StoreAPI<RootState>) {
        thunk(store)
    }
    
    func eraseToAnyThunkAction() -> AnyThunkAction<RootState> {
        AnyThunkAction(self)
    }
}

struct AnyThunkAction<State>: Action {
    private let thunk: (StoreAPI<State>) -> Void
    
    init(_ thunk: Thunk<State>) {
        self.thunk = thunk.callAsFunction(_:)
    }
    
    func callAsFunction(_ store: StoreAPI<State>) {
        thunk(store)
    }
}
