//
//  EmailField.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import FraktalSimplified
import enum Result.NoError

final class EmailField {

    enum Result {
        case valid(String)
        case invalid(String?)
    }

    let result: Property<Result>

    init() {
        self.placeholder = "Email"
        self.emailSink = self.emailPipe.input.send
        self.email = Property(initial: nil, then: self.emailPipe.output)
        self.result = self.email.map(makeResult)
    }

    fileprivate let placeholder: String
    fileprivate let emailSink: (String?) -> Void

    private let email: Property<String?>
    private let emailPipe = Signal<String?, NoError>.pipe()

    deinit {
        self.emailPipe.input.sendInterrupted()
    }
}

extension EmailField: Presentable {

    var present: (EmailFieldPresenters) -> Disposable? {
        return { [weak self] presenters in
            guard let someSelf = self else { return nil }
            let disposable = CompositeDisposable()
            disposable += presenters.placeholder.present(someSelf.placeholder)
            disposable += presenters.sink.present(someSelf.emailSink)
            return disposable
        }
    }
}

extension EmailField.Result: Equatable {
    static func ==(lhs: EmailField.Result, rhs: EmailField.Result) -> Bool {
        switch (lhs, rhs) {
        case let (.valid(l), .valid(r)):
            return l == r
        case let (.invalid(l), .invalid(r)):
            return l == r
        case (.valid, _),
             (.invalid, _):
            return false
        }
    }
}

private func makeResult(email: String?) -> EmailField.Result {
    return email.map { $0.isValidEmail ? .valid($0) : .invalid($0) } ?? .invalid(email)
}

private extension String {
    var isValidEmail: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty && trimmed.rangeOfCharacter(from: .whitespaces) == nil else {
            return false
        }
        let emailRegEx = ".+@.+\\..+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: trimmed)
    }
}
