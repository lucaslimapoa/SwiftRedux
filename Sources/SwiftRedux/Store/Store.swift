//
//  Store.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation
import Combine

public final class Store<State>: ObservableObject, Storable {
    typealias DispatchFunction = (Action) -> Void
    
    @Published public private(set) var state: State
    private var dispatchWithMiddleware: DispatchFunction!
    private var cancellables = Set<AnyCancellable>()

    public convenience init<R>(initialState: State, reducer: R) where R: Reducer, R.State == State {
        self.init(initialState: initialState, reducer: reducer, middleware: NoOpMiddleware())
    }
    
    public init<R, M>(initialState: State, reducer: R, middleware: M) where R: Reducer, R.State == State, M: Middleware, M.State == State {
        self.state = initialState
        
        let storeProxy = StoreProxy(store: self)
        
        self.dispatchWithMiddleware = { action in
            middleware.run(store: storeProxy, action: action)
            reducer.tryReduce(state: &self.state, action: action)
        }
    }
    
    private init(initialState: State, dispatchWithMiddleware: @escaping DispatchFunction) {
        self.state = initialState
        self.dispatchWithMiddleware = dispatchWithMiddleware
    }
    
    public func dispatch(action: Action) {
        dispatchWithMiddleware(action)
    }
    
//    public func dispatch(action thunk: Thunk<State>) {
//        dispatchWithMiddleware(thunk.eraseToAnyThunkAction())
//    }
//
//    public func dispatch(action thunk: ThunkPublisher<State>) {
//        dispatchWithMiddleware(thunk.eraseToAnyThunkActionPublisher())
//    }
    
    public func scope<InnerState>(state keyPath: KeyPath<State, InnerState>) -> Store<InnerState> {
        let scopeStore = Store<InnerState>(
            initialState: state[keyPath: keyPath],
            dispatchWithMiddleware: dispatchWithMiddleware
        )

        $state
            .map(keyPath)
            .assign(to: \.state, on: scopeStore)
            .store(in: &cancellables)

        return scopeStore
    }
}
