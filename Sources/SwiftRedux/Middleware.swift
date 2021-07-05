//
//  Middleware.swift
//  
//
//  Created by Lucas Lima on 02.07.21.
//

import Foundation

public struct Middleware<State, Action> {
    private let middleware: (StoreAPI<State, Action>) -> (@escaping DispatchFunction<Action>) -> (Action) -> Void
    
    public init(_ middlewareFunction: @escaping (StoreAPI<State, Action>, DispatchFunction<Action>, Action) -> Void) {
        self.middleware = { store in
            return { next in
                return { action in
                    return middlewareFunction(store, next, action)
                }
            }
        }
    }
    
    public func callAsFunction(_ store: StoreAPI<State, Action>) -> (@escaping DispatchFunction<Action>) -> (Action) -> Void {
        middleware(store)
    }
}
