//
//  ThunkDispatchable.swift
//  
//
//  Created by Lucas Lima on 12.07.21.
//

import Foundation

protocol ThunkDispatchable {
    func dispatch<State>(action thunk: ThunkAction<State>)
}
