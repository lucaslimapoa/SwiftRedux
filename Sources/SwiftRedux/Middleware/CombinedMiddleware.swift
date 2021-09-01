//
//  CombinedMiddleware.swift
//  
//
//  Created by Lucas Lima on 05.08.21.
//

import Foundation

/**
 A convenience object for combining multiple middlware into one.
 */
public struct CombinedMiddleware<State>: Middleware {
    private let runClosure: (_ store: StoreProxy<State>, _ next: (AnyAction) -> Void, _ action: AnyAction) -> Void
    
    /**
     Combines multiple middleware into a single middleware. It's important to notice that the order the middleware applied is the order they will run.
     
     - Parameter middleware: A middleware to combine.
     
     ```
     CombinedMiddleware<AppState>
        .apply(LoggingMiddleware())
        .apply(ThunkMiddleware())
     ```
     */
    public static func apply<M>(_ middleware: M) -> CombinedMiddleware<State> where M: Middleware, M.State == State {
        CombinedMiddleware(runClosure: middleware.run(store:next:action:))
    }

    /**
     Combines multiple middleware into a single middleware. It's important to notice that the order the middleware applied is the order they will run.
     
     - Parameter anotherMiddleware: A middleware to combine.
     
     ```
     CombinedMiddleware<AppState>
        .apply(LoggingMiddleware())
        .apply(ThunkMiddleware())
     ```
     */
    public func apply<M>(_ anotherMiddleware: M) -> CombinedMiddleware<State> where M: Middleware, M.State == State {
        CombinedMiddleware { store, next, action in
            let nextMiddleware: (AnyAction) -> Void = { anotherAction in
                anotherMiddleware.run(store: store, next: next, action: anotherAction)
            }
            runClosure(store, nextMiddleware, action)
        }
    }

    /**
     A function that will run all combined middleware in the order they were applied.
     */
    public func run(store: StoreProxy<State>, next: (AnyAction) -> Void, action: AnyAction) {
        runClosure(store, next, action)
    }
}
