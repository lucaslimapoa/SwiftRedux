//
//  StoreAPI.swift
//  
//
//  Created by Lucas Lima on 05.07.21.
//

import Foundation

public typealias StoreAPI<State> = (state: () -> State, dispatch: DispatchFunction)
