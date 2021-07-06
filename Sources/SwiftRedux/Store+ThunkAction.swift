//
//  Store+ThunkAction.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

extension Store {
    public func dispatch(action thunk: ThunkAction<State>) {
        dispatch(action: thunk as Action)
    }
}
