//
//  UseDispatch.swift
//  
//
//  Created by Lucas Lima on 31.07.21.
//

import SwiftUI

public struct Dispatcher {
    private let dispatchFunction: DispatchFunction<AnyAction>
    
    init(_ dispatchFunction: @escaping DispatchFunction<AnyAction>) {
        self.dispatchFunction = dispatchFunction
    }
    
    public func callAsFunction(action: AnyAction) {
        dispatchFunction(action)
    }
}

private struct UseDispatchEnvironmentKey: EnvironmentKey {
    static let defaultValue = Dispatcher { _ in
        fatalError("Store not set. Use View.store() function to set up a store.")
    }
}

extension EnvironmentValues {
    public var useDispatch: Dispatcher {
        get { self[UseDispatchEnvironmentKey.self] }
        set { self[UseDispatchEnvironmentKey.self] = newValue }
    }
}
