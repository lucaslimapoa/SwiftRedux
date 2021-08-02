//
//  Dispatcher.swift
//
//
//  Created by Lucas Lima on 01.08.21.
//

import Foundation

public struct Dispatcher<Action> {
    private let dispatchFunction: DispatchFunction<Action>
    
    init(_ dispatchFunction: @escaping DispatchFunction<Action>) {
        self.dispatchFunction = dispatchFunction
    }
    
    public func callAsFunction(action: Action) {
        dispatchFunction(action)
    }
}
