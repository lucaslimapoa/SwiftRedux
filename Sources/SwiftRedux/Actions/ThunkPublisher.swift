//
//  ThunkActionPublisher.swift
//
//
//  Created by Lucas Lima on 19.07.21.
//

import Combine

public struct ThunkPublisher<State> {
    private let thunk: (StoreProxy<State>) -> AnyPublisher<AnyAction, Never>
    
    public init(_ thunk: @escaping (StoreProxy<State>) -> AnyPublisher<AnyAction, Never>) {
        self.thunk = thunk
    }
    
    public func callAsFunction(store: StoreProxy<State>) -> AnyPublisher<AnyAction, Never> {
        thunk(store)
    }
}
