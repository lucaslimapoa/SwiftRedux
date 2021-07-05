//
//  ThunkMiddleware.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

public struct ThunkMiddleware<State, Action>: MiddlewareType {
    private let middleware: (StoreAPI<State, Action>) -> (@escaping DispatchFunction<Action>) -> (Action) -> Void
    
    public init<Context>(context: Context, _ middlewareFunction: @escaping (StoreAPI<State, Action>, DispatchFunction<Action>, Action, Context) -> Void) {
        self.middleware = { store in
            return { next in
                return { action in
                    return middlewareFunction(store, next, action, context)
                }
            }
        }
    }
    
    public func callAsFunction(_ store: StoreAPI<State, Action>) -> (@escaping DispatchFunction<Action>) -> (Action) -> Void {
        middleware(store)
    }
}
