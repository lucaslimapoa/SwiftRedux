//
//  Middleware.swift
//  
//
//  Created by Lucas Lima on 02.07.21.
//

import Foundation

public struct Middleware<State> {
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
}
