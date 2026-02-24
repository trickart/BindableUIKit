//
//  Bindable.swift
//  BindableUIKit
//
//  Created by Ryotaro Seki on 2026/02/24.
//

import Combine
import Foundation

@MainActor @propertyWrapper public class Bindable<View> {
    public var projectedValue: Bindable<View> { self }
    public var wrappedValue: View

    var cancellables: Set<AnyCancellable> = []

    public init(wrappedValue: View) {
        self.wrappedValue = wrappedValue
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>, to keyPath: WritableKeyPath<View, Value>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue[keyPath: keyPath] = value
        }.store(in: &cancellables)
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>,
                            to keyPath: WritableKeyPath<View, Optional<Value>>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue[keyPath: keyPath] = value
        }.store(in: &cancellables)
    }

    public func unbindAll() {
        cancellables.removeAll()
    }
}

@MainActor @propertyWrapper public class WeakBindable<View: AnyObject> {
    public var projectedValue: WeakBindable<View> { self }
    public var wrappedValue: View? {
        get { view }
        set { view = newValue }
    }

    weak var view: View?
    var cancellables: Set<AnyCancellable> = []

    public init(wrappedValue: View?) {
        self.view = wrappedValue
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>, to keyPath: WritableKeyPath<View, Value>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue?[keyPath: keyPath] = value
        }.store(in: &cancellables)
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>,
                            to keyPath: WritableKeyPath<View, Optional<Value>>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue?[keyPath: keyPath] = value
        }.store(in: &cancellables)
    }

    public func unbindAll() {
        cancellables.removeAll()
    }
}
