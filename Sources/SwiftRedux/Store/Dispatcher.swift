//
//  Dispatcher.swift
//  
//
//  Created by Lucas Lima on 05.08.21.
//

import Foundation

/**
 A convenience accessor for the Store's dispatch function.
 Used by the `Dispatch` property wrapper.
 */
public struct Dispatcher<Action> {
    private let dispatchFunction: DispatchFunction<Action>
    
    init(_ dispatchFunction: @escaping DispatchFunction<Action>) {
        self.dispatchFunction = dispatchFunction
    }
    
    public func callAsFunction(action: Action) {
        dispatchFunction(action)
    }
}
