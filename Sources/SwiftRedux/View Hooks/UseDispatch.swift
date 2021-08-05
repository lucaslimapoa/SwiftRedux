//
//  UseDispatch.swift
//  
//
//  Created by Lucas Lima on 01.08.21.
//

import SwiftUI

@propertyWrapper
public struct UseDispatch<ActionType>: DynamicProperty {
    @Environment(\.dispatch) private var dispatch
    
    public var wrappedValue: DispatchFunction<ActionType> {
        dispatch
    }
    
    public init() { }
}
