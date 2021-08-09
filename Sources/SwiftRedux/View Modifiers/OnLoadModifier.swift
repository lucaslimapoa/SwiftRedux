//
//  OnLoadModifier.swift
//
//
//  Created by Lucas Lima on 09.08.21.
//

import SwiftUI

public struct OnLoadModifier: ViewModifier {
    private let action: (() -> Void)?
    @State private var hasLoaded = false
    
    public init(action: (() -> Void)?) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content.onAppear {
            guard !hasLoaded else { return }
            hasLoaded = true
            action?()
        }
    }
}

extension View {
    @inlinable public func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnLoadModifier(action: action))
    }
}
