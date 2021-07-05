//
//  MiddlewareType.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

public protocol MiddlewareType {
    associatedtype State
    associatedtype Action
    func callAsFunction(_ store: StoreAPI<State, Action>) -> (@escaping DispatchFunction<Action>) -> (Action) -> Void
}
