//
//  SelectState.swift
//
//
//  Created by Lucas Lima on 03.08.21.
//

import Combine
import SwiftUI

@propertyWrapper
public struct SelectState<RootState, Value>: DynamicProperty where RootState: Equatable {
    @EnvironmentObject private var store: Store<RootState>
    private let transform: (RootState) -> Value
    
    public var wrappedValue: Value {
        transform(store.state)
    }
    
    public init(_ keyPath: KeyPath<RootState, Value>) {
        self.transform = { state in
            state[keyPath: keyPath]
        }
    }
    
    public init(_ transform: @escaping (RootState) -> Value) {
        self.transform = transform
    }
}
