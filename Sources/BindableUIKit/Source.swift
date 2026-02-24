//
//  Source.swift
//  BindableUIKit
//
//  Created by Ryotaro Seki on 2026/02/24.
//

import Combine

@propertyWrapper public class Source<Value> {
    public let projectedValue: CurrentValueSubject<Value, Never>

    public var wrappedValue: Value {
        get { projectedValue.value }
        set { projectedValue.value = newValue }
    }

    public init(wrappedValue: Value) {
        self.projectedValue = .init(wrappedValue)
    }
}
