//
//  ValueBindable.swift
//  BindableUIKit
//
//  Created by Ryotaro Seki on 2026/02/24.
//

import Combine
import UIKit

@MainActor public protocol ValueBindable: AnyObject {
    associatedtype Value
    var bindableValue: Value { get set }
    func valueDidChangePublisher() -> any Publisher<Value, Never>
}

extension UITextField: ValueBindable {
    public typealias Value = String

    public var bindableValue: String {
        get { text ?? "" }
        set { text = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<String, Never> {
        let subject = PassthroughSubject<String, Never>()
        addAction(.init(handler: { [weak self, weak subject] _ in
            subject?.send(self?.text ?? "")
        }), for: .editingChanged)
        return subject
    }
}

extension UITextView: ValueBindable {
    public typealias Value = String

    public var bindableValue: String {
        get { text ?? "" }
        set { text = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self).compactMap { [weak self] _ in
            guard let self else { return nil }
            return text
        }
    }
}

extension UISwitch: ValueBindable {
    public typealias Value = Bool

    public var bindableValue: Bool {
        get { isOn }
        set { isOn = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<Bool, Never> {
        let subject = PassthroughSubject<Bool, Never>()
        addAction(.init(handler: { [weak self, weak subject] _ in
            guard let self else { return }
            subject?.send(isOn)
        }), for: .valueChanged)
        return subject
    }
}

extension UISlider: ValueBindable {
    public typealias Value = Float

    public var bindableValue: Float {
        get { value }
        set { value = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<Float, Never> {
        let subject = PassthroughSubject<Float, Never>()
        addAction(.init(handler: { [weak self, weak subject] _ in
            guard let self else { return }
            subject?.send(value)
        }), for: .valueChanged)
        return subject
    }
}

extension UIStepper: ValueBindable {
    public typealias Value = Double

    public var bindableValue: Double {
        get { value }
        set { value = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<Double, Never> {
        let subject = PassthroughSubject<Double, Never>()
        addAction(.init(handler: { [weak self, weak subject] _ in
            guard let self else { return }
            subject?.send(value)
        }), for: .valueChanged)
        return subject
    }
}

extension UISegmentedControl: ValueBindable {
    public typealias Value = Int

    public var bindableValue: Int {
        get { selectedSegmentIndex }
        set { selectedSegmentIndex = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<Int, Never> {
        let subject = PassthroughSubject<Int, Never>()
        addAction(.init(handler: { [weak self, weak subject] _ in
            guard let self else { return }
            subject?.send(selectedSegmentIndex)
        }), for: .valueChanged)
        return subject
    }
}

extension UIDatePicker: ValueBindable {
    public typealias Value = Date

    public var bindableValue: Date {
        get { date }
        set { date = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<Date, Never> {
        let subject = PassthroughSubject<Date, Never>()
        addAction(.init(handler: { [weak self, weak subject] _ in
            guard let self else { return }
            subject?.send(date)
        }), for: .valueChanged)
        return subject
    }
}

extension UIPageControl: ValueBindable {
    public typealias Value = Int

    public var bindableValue: Int {
        get { currentPage }
        set { currentPage = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<Int, Never> {
        let subject = PassthroughSubject<Int, Never>()
        addAction(.init(handler: { [weak self, weak subject] _ in
            guard let self else { return }
            subject?.send(currentPage)
        }), for: .valueChanged)
        return subject
    }
}

extension UISearchBar: ValueBindable {
    public typealias Value = String

    public var bindableValue: String {
        get { searchTextField.text ?? "" }
        set { searchTextField.text = newValue }
    }

    public func valueDidChangePublisher() -> any Publisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchTextField).compactMap { [weak self] _ in
            guard let self else { return nil }
            return searchTextField.text
        }
    }
}
