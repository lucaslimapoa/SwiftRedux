//
//  AnyStorable.swift
//  
//
//  Created by Lucas Lima on 03.08.21.
//

import Foundation

final class AnyStorable: Storable {
    private let stateClosure: () -> Any
    private let dispatchClosure: (AnyAction) -> Void

    var state: Any {
        stateClosure()
    }
    
    init<S>(_ store: S) where S: Storable, S.State: Equatable {
        self.stateClosure = {
            store.state
        }
        
        self.dispatchClosure = { action in
            store.dispatch(action: action)
        }
    }
    
    func dispatch<Action>(action: Action) {
        dispatchClosure(action)
    }
}
