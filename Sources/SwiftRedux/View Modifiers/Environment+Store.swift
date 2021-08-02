//
//  StoreEnvironmentKey.swift
//  
//
//  Created by Lucas Lima on 03.08.21.
//

import SwiftUI

private struct StoreEnvironmentKey: EnvironmentKey {
    static let defaultValue: AnyStorable? = nil
}

extension EnvironmentValues {
    var store: AnyStorable? {
        get { self[StoreEnvironmentKey.self] }
        set { self[StoreEnvironmentKey.self] = newValue }
    }
}
