//
//  Store.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation
import Combine

public final class Store<State>: ObservableObject {
    @Published public private(set) var state: State
    private let reducer: Reducer<State>
    private var dispatchWithMiddleware: CombinedMiddleware!
    
    public init(initialState: State, reducer: Reducer<State>, middleware: [Middleware<State>] = []) {
        self.state = initialState
        self.reducer = reducer
        self.dispatchWithMiddleware = CombinedMiddleware(middleware, store: ({ [unowned self] in self.state }, storeDispatch))
    }
            
    private func storeDispatch(action: Action) {
        state = reducer(state, action)
    }
    
    public func dispatch(action: Action) {
        dispatchWithMiddleware(action: action)
    }
    
    public func sliceStore<InnerState, ActionType>(state: KeyPath<State, InnerState>,
                                                   actionType: ActionType.Type) -> StoreSlice<InnerState, ActionType> {
        StoreSlice(
            storeAPI: (
                state: { self.state[keyPath: state] },
                dispatch: dispatch(action:)
            )
        )
    }
}

