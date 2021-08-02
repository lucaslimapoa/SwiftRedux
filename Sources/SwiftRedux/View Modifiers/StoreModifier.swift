//
//  StoreModifier.swift
//
//
//  Created by Lucas Lima on 31.07.21.
//

import SwiftUI

extension View {
    @discardableResult
    public func store<S>(_ store: S) -> some View where S: Storable, S: ObservableObject, S.State: Equatable {
        // Need to find a way to unit test this
        // When the unit tests run, the environment object is nil
        environmentObject(store)
            .environment(\.store, AnyStorable(store))
    }
}
