//
//  UseDispatch.swift
//  
//
//  Created by Lucas Lima on 01.08.21.
//

import SwiftUI

@propertyWrapper
public struct Dispatch<ActionType>: DynamicProperty {
    @Environment(\.dispatch) private var dispatch
    
    public var wrappedValue: Dispatcher<ActionType> {
        Dispatcher { action in
            dispatch(action: action)
        }
    }
    
    public init() { }
}
