//
//  ThunkMiddleware.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import SwiftUI
import Combine

/**
 A middleware responsible for handling `Thunk<State>` and `ThunkPublisher<State>` actions.
 Such actions are handled and then prevented from going through the next middleware.
 */
public final class ThunkMiddleware<State>: Middleware {
    private var cancellables = Set<AnyCancellable>()
    
    public init() { }
    
    public func run(store: StoreProxy<State>, next: (AnyAction) -> Void, action: AnyAction) {
        if let thunk = action as? Thunk<State> {
            thunk(store: store)
        } else if let thunkPublisher = action as? ThunkPublisher<State> {
            thunkPublisher(store: store)
                .sink(receiveValue: store.dispatch)
                .store(in: &cancellables)
        } else {
            next(action)
        }
    }
}
