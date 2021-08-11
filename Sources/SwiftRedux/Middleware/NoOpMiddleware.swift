//
//  NoOpMiddleware.swift
//  
//
//  Created by Lucas Lima on 26.07.21.
//

import Foundation

struct NoOpMiddleware<State>: Middleware {
    func run(store: StoreProxy<State>, next: (AnyAction) -> Void, action: AnyAction) {
        next(action)
    }
}
