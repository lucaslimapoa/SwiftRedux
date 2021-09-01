//
//  LoggingMiddleware.swift
//
//
//  Created by Lucas Lima on 17.08.21.
//

import Foundation

/**
 A logging middleware that outputs to the Xcode console an action that caused the state to change as well as the old and new state, represented with ---- and ++++ respectively.
 */
public final class LoggingMiddleware<State>: Middleware {
    private var previousLogString = ""
    
    public init() { }
    
    public func run(store: StoreProxy<State>, next: (AnyAction) -> Void, action: AnyAction) {
        let previousStateMirror = Mirror(reflecting: store.state)
        next(action)
        let currentStateMirror = Mirror(reflecting: store.state)
        
        let currentLogString = diff(lhsState: previousStateMirror, rhsState: currentStateMirror)
        
        if currentLogString != previousLogString {
            print(
                """
                ------------------------------
                Action
                  \(action)
                
                \(String(describing: State.self))
                \(currentLogString)
                """
            )
            previousLogString = currentLogString
        }
    }
    
    private func diff(lhsState: Mirror, rhsState: Mirror) -> String {
        zip(lhsState.children, rhsState.children)
            .reduce(into: "") { resultString, mirrorParams in
                guard let label = mirrorParams.1.label else { return }
                let previousValue = String(describing: mirrorParams.0.value)
                let currentValue = String(describing: mirrorParams.1.value)
                
                if previousValue == currentValue {
                    resultString += "  \(label): \(currentValue)\n"
                } else {
                    resultString += "  ---- \(label): \(previousValue)\n"
                    resultString += "  ++++ \(label): \(currentValue)\n"
                }
            }
    }
}
