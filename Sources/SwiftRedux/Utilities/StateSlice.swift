//
//  StateSlice.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation
import SwiftUI

@dynamicMemberLookup
public struct StateSlice<T> {
    private let state: T
    
    init(state: T) {
        self.state = state
    }
    
    public subscript<Value>(dynamicMember keyPath: KeyPath<T, Value>) -> Value {
        state[keyPath: keyPath]
    }
}
