//
//  SelectState.swift
//
//
//  Created by Lucas Lima on 03.08.21.
//

import Combine
import SwiftUI

/**
 A property wrapper for extracting a given field from the Store in the SwiftUI view environment.
 Each time the State is updated within the store, the SwiftUI View will be invalidated and the property wrapper will have the new state.
 */
@propertyWrapper
public struct SelectState<RootState, Value>: DynamicProperty where RootState: Equatable {
    @EnvironmentObject private var store: Store<RootState>
    private let transform: (RootState) -> Value
    
    public var wrappedValue: Value {
        transform(store.state)
    }
    
    /**
     A property wrapper for extracting a given field from the Store in the SwiftUI view environment.
     
     - Parameter keyPath: A KeyPath from the Store's State.
     
     ```
     struct SomeView: View {
        @SelectState(\AppState.greeting) private var greeting
        
        var body: some View {
            Text(greeting)
        }
     }
     ```
     Each time the State is updated within the store, the SwiftUI View will be invalidated and the property wrapper will have the new state.
    */
    public init(_ keyPath: KeyPath<RootState, Value>) {
        self.transform = { state in
            state[keyPath: keyPath]
        }
    }
    
    /**
     A property wrapper for extracting a given field from the Store in the SwiftUI view environment.
     A closure for transforming the Store's state can be used to construct the new state
     
     - Parameter transform: A closure for transforming the entire Store's State into a single value.
     
     ```
     struct SomeView: View {
        @SelectState(mapToGreeting) private var greeting
        
        var body: some View {
            Text(greeting)
        }
     
        private static func mapToGreeting(state: AppState) -> String {
            "Hello \(state.firstName) \(state.lastName)"
        }
     }
     ```
     Each time the State is updated within the store, the SwiftUI View will be invalidated and the property wrapper will have the new state.
    */
    public init(_ transform: @escaping (RootState) -> Value) {
        self.transform = transform
    }
}
