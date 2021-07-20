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
    private var dispatchWithMiddleware: DispatchFunction!
    private var cancellables = Set<AnyCancellable>()
    
    public init<T>(initialState: State, reducer: Reducer<State, T>, middleware: [Middleware<State>] = []) {
        self.state = initialState
        
        let getState = { [unowned self] in self.state }
        
        let dispatch: DispatchFunction = { [unowned self] action in
            guard let action = action as? T else { return }
            reducer(&self.state, action)
        }
        
        self.dispatchWithMiddleware = Middleware.apply(middleware, storeAPI: (getState, dispatch))
    }
    
    public init(initialState: State, reducer: CombinedReducer<State>, middleware: [Middleware<State>] = []) {
        self.state = initialState
        
        let getState = { [unowned self] in self.state }
        
        let dispatch: DispatchFunction = { [unowned self] action in
            reducer(&self.state, action)
        }
        
        self.dispatchWithMiddleware = Middleware.apply(middleware, storeAPI: (getState, dispatch))
    }
    
    private init(initialState: State, dispatchWithMiddleware: @escaping DispatchFunction) {
        self.state = initialState
        self.dispatchWithMiddleware = dispatchWithMiddleware
    }
    
    public func dispatch(action: Action) {
        dispatchWithMiddleware(action)
    }
    
    public func scope<InnerState>(state keyPath: KeyPath<State, InnerState>) -> Store<InnerState> {
        let scopeStore = Store<InnerState>(
            initialState: state[keyPath: keyPath],
            dispatchWithMiddleware: Middleware<InnerState>.apply(
                [.thunkMiddleware],
                storeAPI: (
                    { self.state[keyPath: keyPath] },
                    dispatchWithMiddleware
                )
            )
        )
        
        $state
            .map(keyPath)
            .assign(to: \.state, on: scopeStore)
            .store(in: &cancellables)
        
        return scopeStore
    }
}
