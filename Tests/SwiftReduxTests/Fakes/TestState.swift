//
//  TestState.swift
//  
//
//  Created by Lucas Lima on 06.07.21.
//

import Foundation

struct InnerState: Equatable {
    var counter = 0
}

struct TestState: Equatable {
    var counter = 0
    var innerState = InnerState()
}
