//
//  ThunkActionPublisher.swift
//
//
//  Created by Lucas Lima on 19.07.21.
//

import Combine

public struct ThunkActionPublisher<State>: Action {
    private let thunk: (StoreAPI<State>) -> AnyPublisher<Action, Never>
    
    public init(_ thunk: @escaping (StoreAPI<State>) -> AnyPublisher<Action, Never>) {
        self.thunk = thunk
    }
    
    public func callAsFunction(_ store: StoreAPI<State>) -> AnyPublisher<Action, Never> {
        thunk(store)
    }
}
