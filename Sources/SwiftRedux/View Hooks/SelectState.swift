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
    private let keyPath: AnyKeyPath
    
    public var wrappedValue: Value {
        guard let state = store.state[keyPath: keyPath] as? Value else {
                  fatalError("Store not registered or used from View.init() or invalid root type. Use .store(_:) modifier to register the store. SelectState can only be used from `var body: some View`.")
        }
        
        return state
    }
    
    public init(_ keyPath: KeyPath<RootState, Value>) where Value: Equatable, RootState: Equatable {
        self.keyPath = keyPath
    }
}
