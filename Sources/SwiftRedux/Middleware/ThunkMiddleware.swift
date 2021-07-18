//
//  ThunkMiddleware.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

extension Middleware {
    public static var thunkMiddleware: Middleware {
        Middleware<State> { store, next, action in
            if let thunk = action as? ThunkAction<State> {
                thunk(store)
            }
            
            next(action)
        }
    }
}
