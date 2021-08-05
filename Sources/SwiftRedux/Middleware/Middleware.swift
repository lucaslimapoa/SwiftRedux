//
//  Middleware.swift
//  
//
//  Created by Lucas Lima on 02.07.21.
//

import Foundation

public protocol Middleware {
    associatedtype State
    func run(store: StoreProxy<State>, action: AnyAction)
}
