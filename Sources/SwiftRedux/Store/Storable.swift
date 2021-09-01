//
//  Storeable.swift
//
//
//  Created by Lucas Lima on 26.07.21.
//

import Foundation

/**
 A protocol that the Store class conforms to.
 This is used so that any StoreProxy can be created from an object conforming to Storable.
 */
public protocol Storable: AnyObject {
    associatedtype State
    var state: State { get }
    
    func dispatch<Action>(action: Action)
}
