//
//  ThunkActionPublisher.swift
//
//
//  Created by Lucas Lima on 19.07.21.
//

import Combine

public struct ThunkActionPublisher<RootState> {
    private let thunk: (StoreAPI<RootState>) -> AnyPublisher<Action, Never>
    
    public init(_ thunk: @escaping (StoreAPI<RootState>) -> AnyPublisher<Action, Never>) {
        self.thunk = thunk
    }
    
    public func callAsFunction(_ store: StoreAPI<RootState>) -> AnyPublisher<Action, Never> {
        thunk(store)
    }
    
    func eraseToAnyThunkAction() -> AnyThunkActionPublisher<RootState> {
        AnyThunkActionPublisher(self)
    }
}

struct AnyThunkActionPublisher<State>: Action {
    private let thunk: (StoreAPI<State>) -> AnyPublisher<Action, Never>
    
    init(_ thunk: ThunkActionPublisher<State>) {
        self.thunk = thunk.callAsFunction(_:)
    }
    
    func callAsFunction(_ store: StoreAPI<State>) -> AnyPublisher<Action, Never> {
        thunk(store)
    }
}
