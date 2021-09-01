//
//  StoreModifier.swift
//
//
//  Created by Lucas Lima on 31.07.21.
//

import SwiftUI

extension View {
    /**
     Adds an instance of the a Store to the SwiftUI Environment, so that the `@SelectState` and `@Dispatch` property wrappers can be used.
     The store should be inserted in the first view where the Store's state is used, so that children view will also have access to it.
     
     - Parameter store: A store instance to be set in the SwiftUI Environment.
       
     ```
     InitialView()
         .store(SomeStore())
     ```
    */
    @discardableResult
    public func store<S>(_ store: S) -> some View where S: Storable, S: ObservableObject, S.State: Equatable {
        // Need to find a way to unit test this
        // When the unit tests run, the environment object is nil
        environmentObject(store)
            .environment(\.dispatch, Dispatcher(store.dispatch(action:)))
    }
}
