//
//  Middleware.swift
//  
//
//  Created by Lucas Lima on 02.07.21.
//

import Foundation

/**
 A protocol that all Middleware must conform to.
 A reducer is an object that changes the state based on the action received.
 */
public protocol Middleware {
    associatedtype State
    /**
     Handles a given action, if necessary, and extends behavior of the Store.
     
     - Parameter store: A proxy to the store, so the state and disptach can be accessed from the Middleware.
     
     - Parameter next: A closure for calling the next middleware with the current action.
     If `next(action)` is not called, the midleware stops handling the action and no reducer will handle the action.
     This is useful when handling actions that are specific to a middleware and don't need to be reduced, such as the `Thunk<State>` and `ThunkPublisher<State>`.
     
     - Parameter action: The action dispatched to the store.
     
     ```
     struct SimpleLoggingMiddleware<State>: Middleware {
         public func run(store: StoreProxy<State>, next: (AnyAction) -> Void, action: AnyAction) {
            print(store.state) // old state
            
            next(action) // action will be handled by the reducers
            
            print(store.state) // new state
         }
     }
     ```
     */
    func run(store: StoreProxy<State>, next: (AnyAction) -> Void, action: AnyAction)
}
