//
//  CombinedMiddleware.swift
//  
//
//  Created by Lucas Lima on 14.07.21.
//

import Foundation

struct CombinedMiddleware {
    private let dispatchFunction: DispatchFunction
    
    init<State>(_ middleware: [Middleware<State>], store: StoreAPI<State>) {
        dispatchFunction = middleware.reversed()
            .reduce({ action in store.dispatch(action) }) { current, next in
                next(store)(current)
            }
    }
    
    func callAsFunction(action: Action) {
        dispatchFunction(action)
    }
}
