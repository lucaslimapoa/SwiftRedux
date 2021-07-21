//
//  Store.swift
//  
//
//  Created by Lucas Lima on 01.07.21.
//

import Foundation
import Combine

public final class Store<RootState>: ObservableObject {
    @Published public private(set) var state: RootState
    private var dispatchWithMiddleware: DispatchFunction!
    private var cancellables = Set<AnyCancellable>()
    
    public init<T>(initialState: RootState, reducer: Reducer<RootState, T>, middleware: [Middleware<RootState>] = []) {
        self.state = initialState
        
        let getState = { [unowned self] in self.state }
        
        let dispatch: DispatchFunction = { [unowned self] action in
            guard let action = action as? T else { return }
            reducer(&self.state, action)
        }
        
        self.dispatchWithMiddleware = Middleware.apply(middleware, storeAPI: (getState, dispatch))
    }
    
    public init(initialState: RootState, reducer: CombinedReducer<RootState>, middleware: [Middleware<RootState>] = []) {
        self.state = initialState
        
        let getState = { [unowned self] in self.state }
        
        let dispatch: DispatchFunction = { [unowned self] action in
            reducer(&self.state, action)
        }
        
        self.dispatchWithMiddleware = Middleware.apply(middleware, storeAPI: (getState, dispatch))
    }
    
    private init(initialState: RootState, dispatchWithMiddleware: @escaping DispatchFunction) {
        self.state = initialState
        self.dispatchWithMiddleware = dispatchWithMiddleware
    }
    
    public func dispatch(action: Action) {
        dispatchWithMiddleware(action)
    }
    
    public func dispatch(action thunk: ThunkAction<RootState>) {
        dispatchWithMiddleware(thunk.eraseToAnyThunkAction())
    }
    
    public func dispatch(action thunk: ThunkActionPublisher<RootState>) {
        dispatchWithMiddleware(thunk.eraseToAnyThunkAction())
    }
    
    public func scope<InnerState>(state keyPath: KeyPath<RootState, InnerState>) -> Store<InnerState> {
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
