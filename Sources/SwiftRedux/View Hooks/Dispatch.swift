//
//  UseDispatch.swift
//  
//
//  Created by Lucas Lima on 01.08.21.
//

import SwiftUI

/**
 A property wrapper for extracting the Dispatch function of the Store in the SwiftUI view environment.
 ```
 struct SomeView: View {
    @Dispatch<AnyAction> private var dispatch
    
    var body: some View {
        Text("Hello")
            .onAppear { dispatch(action: FetchAction.loadAll) }
    }
 }
 ```
 */
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
