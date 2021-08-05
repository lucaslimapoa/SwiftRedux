//
//  StoreEnvironmentKey.swift
//  
//
//  Created by Lucas Lima on 03.08.21.
//

import SwiftUI

private struct DispatchEnvironmentKey: EnvironmentKey {
    static let defaultValue: Dispatcher<AnyAction> = Dispatcher { _ in
        fatalError("Store not registered or used from View.init(). Use .store(_:) modifier to register the store. UseDispatch can only be used from `var body: some View`.")
    }
}

extension EnvironmentValues {
    var dispatch: Dispatcher<AnyAction> {
        get { self[DispatchEnvironmentKey.self] }
        set { self[DispatchEnvironmentKey.self] = newValue }
    }
}
