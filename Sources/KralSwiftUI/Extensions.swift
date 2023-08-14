//
//  File.swift
//  
//
//  Created by Kral on 14/8/2023.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
