//
//  Store+SliceStore.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

extension Store {    
    public func sliceStore<InnerState, ActionType>(state: KeyPath<State, InnerState>,
                                                   actionType: ActionType.Type) -> StoreSlice<InnerState, ActionType> {
        StoreSlice(
            state: { self.state[keyPath: state] },
            dispatch: dispatch(action:)
        )
    }
}
