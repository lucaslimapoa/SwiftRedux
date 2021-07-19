//
//  Middleware.swift
//  
//
//  Created by Lucas Lima on 02.07.21.
//

import Foundation

public protocol MiddlewareType {
    associatedtype State
    func callAsFunction(_ store: StoreAPI<State>) -> (@escaping DispatchFunction) -> (Action) -> Void
}

public struct Middleware<State>: MiddlewareType {
    private let middleware: (StoreAPI<State>) -> (@escaping DispatchFunction) -> (Action) -> Void
    
    public init(_ middlewareFunction: @escaping (StoreAPI<State>, DispatchFunction, Action) -> Void) {
        self.middleware = { store in
            return { next in
                return { action in
                    return middlewareFunction(store, next, action)
                }
            }
        }
    }
    
    public func callAsFunction(_ store: StoreAPI<State>) -> (@escaping DispatchFunction) -> (Action) -> Void {
        middleware(store)
    }
    
    public static func apply(_ middleware: [Middleware<State>], storeAPI: StoreAPI<State>) -> DispatchFunction {
        middleware.reversed()
            .reduce({ action in storeAPI.dispatch(action) }) { current, next in
                next(storeAPI)(current)
            }
    }
}
