//
//  ThunkMiddleware.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

public func createThunkMiddleware<State>() -> Middleware<State> {
    return Middleware<State> { store, next, action in
        if let thunk = action as? ThunkAction<State> {
            thunk(store)
        }
        
        next(action)
    }
}
