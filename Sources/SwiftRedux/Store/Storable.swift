//
//  Storeable.swift
//
//
//  Created by Lucas Lima on 26.07.21.
//

import Foundation

protocol Storable: AnyObject {
    associatedtype State
    var state: State { get }
    
    func dispatch<Action>(action: Action)
}
