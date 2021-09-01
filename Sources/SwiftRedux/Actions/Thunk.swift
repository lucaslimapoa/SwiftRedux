//
//  ThunkAction.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation
import CloudKit

/**
 An action used for running async logic, such as API requests.
 */
public struct Thunk<State> {
    private let thunk: (StoreProxy<State>) -> Void
    
    public init(_ thunk: @escaping (StoreProxy<State>) -> Void) {
        self.thunk = thunk
    }
    
    public func callAsFunction(store: StoreProxy<State>) {
        thunk(store)
    }
}
