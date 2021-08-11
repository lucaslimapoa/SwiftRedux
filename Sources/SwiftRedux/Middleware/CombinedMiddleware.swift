//
//  CombinedMiddleware.swift
//  
//
//  Created by Lucas Lima on 05.08.21.
//

import Foundation

public struct CombinedMiddleware<State>: Middleware {
    private let runClosure: (_ store: StoreProxy<State>, _ next: (AnyAction) -> Void, _ action: AnyAction) -> Void
    
    public static func apply<M>(_ middleware: M) -> CombinedMiddleware<State> where M: Middleware, M.State == State {
        CombinedMiddleware(runClosure: middleware.run(store:next:action:))
    }

    public func apply<M>(_ anotherMiddleware: M) -> CombinedMiddleware<State> where M: Middleware, M.State == State {
        CombinedMiddleware { store, next, action in
            let nextMiddleware: (AnyAction) -> Void = { anotherAction in
                anotherMiddleware.run(store: store, next: next, action: anotherAction)
            }
            runClosure(store, nextMiddleware, action)
        }
    }

    public func run(store: StoreProxy<State>, next: (AnyAction) -> Void, action: AnyAction) {
        runClosure(store, next, action)
    }
}
