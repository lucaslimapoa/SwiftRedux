//
//  UseDispatch.swift
//  
//
//  Created by Lucas Lima on 01.08.21.
//

import SwiftUI

@propertyWrapper
public struct UseDispatch<ActionType>: DynamicProperty {
    @Environment(\.store) private var store
    
    public var wrappedValue: DispatchFunction<ActionType> {
        guard let store = store else {
            fatalError("Store not registered or used from View.init(). Use .store(_:) modifier to register the store. UseDispatch can only be used from `var body: some View`.")
        }
        
        return store.dispatch(action:)
    }
    
    public init() { }
}
