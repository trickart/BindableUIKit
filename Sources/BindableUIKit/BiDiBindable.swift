//
//  BiDiBindable.swift
//  BindableUIKit
//
//  Created by Ryotaro Seki on 2026/02/24.
//

import Combine
import Foundation

@MainActor @propertyWrapper public class BiDiBindable<View: ValueBindable> {
    public var projectedValue: BiDiBindable<View> { self }

    public var wrappedValue: View {
        didSet {
            viewCancellable?.cancel()
            viewCancellable = wrappedValue.valueDidChangePublisher().sink { [weak self] value in
                guard let self else { return }
                guard !self.isProgrammaticUpdate else { return }
                subject.send(value)
            }
        }
    }

    let subject = PassthroughSubject<View.Value, Never>()
    var unidirectionalCancellables: Set<AnyCancellable> = []
    var bidirectionalCancellables: Set<AnyCancellable> = []
    var viewCancellable: AnyCancellable?
    var isProgrammaticUpdate = false

    public init(wrappedValue: View) {
        self.wrappedValue = wrappedValue
        viewCancellable = wrappedValue.valueDidChangePublisher().sink { [weak self] value in
            guard let self else { return }
            guard !self.isProgrammaticUpdate else { return }
            subject.send(value)
        }
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>,
                            to keyPath: WritableKeyPath<View, Value>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue[keyPath: keyPath] = value
        }.store(in: &unidirectionalCancellables)
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>,
                            to keyPath: WritableKeyPath<View, Optional<Value>>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue[keyPath: keyPath] = value
        }.store(in: &unidirectionalCancellables)
    }

    public func bind(with sourceSubject: some Subject<View.Value, Never>) {
        bidirectionalCancellables.removeAll()

        sourceSubject.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.isProgrammaticUpdate = true
            self?.wrappedValue.bindableValue = value
            self?.isProgrammaticUpdate = false
        }.store(in: &bidirectionalCancellables)
        subject.sink { [weak sourceSubject] value in
            sourceSubject?.send(value)
        }.store(in: &bidirectionalCancellables)
    }

    public func unbindAll() {
        unidirectionalCancellables.removeAll()
        bidirectionalCancellables.removeAll()
        viewCancellable = nil
    }
}

@MainActor @propertyWrapper public class WeakBiDiBindable<View: ValueBindable> {
    public var projectedValue: WeakBiDiBindable<View> { self }
    public var wrappedValue: View? {
        get { view }
        set {
            view = newValue
            viewCancellable?.cancel()
            viewCancellable = wrappedValue?.valueDidChangePublisher().sink { [weak self] value in
                guard let self else { return }
                guard !self.isProgrammaticUpdate else { return }
                subject.send(value)
            }
        }
    }

    weak var view: View?
    let subject = PassthroughSubject<View.Value, Never>()
    var unidirectionalCancellables: Set<AnyCancellable> = []
    var bidirectionalCancellables: Set<AnyCancellable> = []
    var viewCancellable: AnyCancellable?
    var isProgrammaticUpdate = false

    public init(wrappedValue: View?) {
        self.view = wrappedValue
        viewCancellable = wrappedValue?.valueDidChangePublisher().sink { [weak self] value in
            guard let self else { return }
            guard !self.isProgrammaticUpdate else { return }
            subject.send(value)
        }
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>,
                            to keyPath: WritableKeyPath<View, Value>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue?[keyPath: keyPath] = value
        }.store(in: &unidirectionalCancellables)
    }

    public func bind<Value>(_ publisher: some Publisher<Value, Never>,
                            to keyPath: WritableKeyPath<View, Optional<Value>>) {
        publisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.wrappedValue?[keyPath: keyPath] = value
        }.store(in: &unidirectionalCancellables)
    }

    public func bind(with sourceSubject: some Subject<View.Value, Never>) {
        bidirectionalCancellables.removeAll()

        sourceSubject.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.isProgrammaticUpdate = true
            self?.wrappedValue?.bindableValue = value
            self?.isProgrammaticUpdate = false
        }.store(in: &bidirectionalCancellables)
        subject.sink { [weak sourceSubject] value in
            sourceSubject?.send(value)
        }.store(in: &bidirectionalCancellables)
    }

    public func unbindAll() {
        unidirectionalCancellables.removeAll()
        bidirectionalCancellables.removeAll()
        viewCancellable = nil
    }
}
