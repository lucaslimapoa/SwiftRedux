//
//  CombinedMiddleware.swift
//  
//
//  Created by Lucas Lima on 05.08.21.
//

import Foundation

public struct CombinedMiddleware<State>: Middleware {
    private let runClosure: (_ store: StoreProxy<State>, _ action: AnyAction) -> Void
    
    public static func apply<M>(_ middleware: M) -> CombinedMiddleware<State> where M: Middleware, M.State == State {
        CombinedMiddleware(runClosure: middleware.run(store:action:))
    }

    public func apply<M>(_ anotherMiddleware: M) -> CombinedMiddleware<State> where M: Middleware, M.State == State {
        CombinedMiddleware { store, action in
            runClosure(store, action)
            anotherMiddleware.run(store: store, action: action)
        }
    }

    public func run(store: StoreProxy<State>, action: AnyAction) {
        runClosure(store, action)
    }
}
