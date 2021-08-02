//
//  UseDispatch.swift
//  
//
//  Created by Lucas Lima on 01.08.21.
//

import SwiftUI

@propertyWrapper
public struct UseDispatch<ActionType>: DynamicProperty {
    private let store: Environment<AnyStorable?>
    private let storage: UseDispatchStorage<ActionType>
    
    public var wrappedValue: Dispatcher<ActionType> {
        storage.makeDispatcher(with: store.wrappedValue)
    }
    
    public init() {
        self.store = Environment<AnyStorable?>(\.store)
        self.storage = UseDispatchStorage()
    }
}

final class UseDispatchStorage<ActionType> {
    private var dispatcher: Dispatcher<ActionType>?
    
    func makeDispatcher(with store: AnyStorable?) -> Dispatcher<ActionType> {
        guard let store = store else {
            fatalError("Store not registered or used from View.init(). Use .store(_:) modifier to register the store. UseDispatch can only be used from `var body: some View`.")
        }
        
        if let dispatcher = dispatcher {
            return dispatcher
        }
        
        let newDispatcher = Dispatcher<ActionType>(store.dispatch(action:))
        dispatcher = newDispatcher
        
        return newDispatcher
    }
}
