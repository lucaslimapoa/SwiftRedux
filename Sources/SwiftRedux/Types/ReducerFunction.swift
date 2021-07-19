//
//  ReducerFunction.swift
//
//
//  Created by Lucas Lima on 19.07.21.
//

import Foundation

public typealias ReducerFunction<State> = (_ state: inout State, _ action: Action) -> Void
