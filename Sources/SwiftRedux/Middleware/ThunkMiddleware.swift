//
//  ThunkMiddleware.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import SwiftUI
import Combine

struct ThunkMiddleware<State>: Middleware {
    private var cancellables = Set<AnyCancellable>()
    
    func run(store: StoreProxy<State>, action: Action) {
//        if let thunk = action as? AnyThunkAction<State> {
//            thunk(store)
//        } else if let thunkPublisher = action as? AnyThunkActionPublisher<State> {
//            thunkPublisher(store)
//                .sink(receiveValue: store.dispatch)
//                .store(in: &cancellables)
//        }
    }
}
