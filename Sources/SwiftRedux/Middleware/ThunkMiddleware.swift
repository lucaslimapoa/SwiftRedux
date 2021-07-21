//
//  ThunkMiddleware.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import SwiftUI
import Combine

extension Middleware {
    public static var thunkMiddleware: Middleware {
        var cancellables = Set<AnyCancellable>()
        return Middleware<State> { store, next, action in
            if let thunk = action as? AnyThunkAction<State> {
                thunk(store)
            } else if let thunkPublisher = action as? AnyThunkActionPublisher<State> {
                thunkPublisher(store)
                    .sink(receiveValue: store.dispatch)
                    .store(in: &cancellables)
            }
            
            next(action)
        }
    }
}
