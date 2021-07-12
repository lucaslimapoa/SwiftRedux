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
    private var dispatchWithMiddleware: DispatchFunction!
    
    public init(initialState: State, reducer: Reducer<State>, middleware: [Middleware<State>] = []) {
        self.state = initialState
        self.reducer = reducer
        self.dispatchWithMiddleware = Self.applyMiddleware(middleware, store: ({ [unowned self] in self.state }, storeDispatch))
    }
    
    private static func applyMiddleware(_ middleware: [Middleware<State>], store: StoreAPI<State>) -> (Action) -> Void {
        middleware.reversed()
            .reduce({ action in store.dispatch(action) }) { current, next in
                next(store)(current)
            }
    }
        
    private func storeDispatch(action: Action) {
        state = reducer(state, action)
    }
    
    public func dispatch(action: Action) {
        dispatchWithMiddleware(action)
    }
    
    public func sliceStore<InnerState, ActionType>(state: KeyPath<State, InnerState>,
                                                   actionType: ActionType.Type) -> StoreSlice<InnerState, ActionType> {
        StoreSlice(
            state: { self.state[keyPath: state] },
            dispatch: dispatch(action:)
        )
    }
}

