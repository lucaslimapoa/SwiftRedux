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
    private let keyPath: KeyPath<RootState, Value>
    
    public var wrappedValue: Value {
        store.state[keyPath: keyPath]
    }
    
    public init(_ keyPath: KeyPath<RootState, Value>) where Value: Equatable, RootState: Equatable {
        self.keyPath = keyPath
    }
}
