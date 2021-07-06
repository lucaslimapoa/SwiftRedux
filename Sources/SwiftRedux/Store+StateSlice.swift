//
//  Store+StateSlice.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

extension Store {
    public func sliceState<InnerState>(_ innerState: KeyPath<State, InnerState>) -> StateSlice<InnerState> {
        StateSlice(state: state[keyPath: innerState])
    }
}
