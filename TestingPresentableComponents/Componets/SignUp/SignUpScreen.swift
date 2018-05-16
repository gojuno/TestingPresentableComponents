//
//  SignUpScreen.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import FraktalSimplified
import enum Result.NoError

final class SignUpScreen {

    enum Result {
        case back
    }

    let result: Signal<Result, NoError>

    init() {
        self.title = "Sign Up"
        self.backTitle = "Back"
        self.backSink = self.backPipe.input.send
        self.passwordPlaceholder = "Password"
        self.passwordSink = self.passwordPipe.input.send
        self.email = EmailField()
        self.result = self.backPipe.output.map { .back }
        self.signUpTitle = "Sign Up"
        let validatedPassword = self.passwordPipe.output.producer
            .map { $0.flatMap { $0.count > 5 ? $0 : nil } }
        let validatedEmail = self.email.result.producer.map { result -> String? in
            switch result {
            case let .valid(email): return email
            case .invalid: return nil
            }
        }
        let credentials = SignalProducer
            .combineLatest(validatedEmail, validatedPassword)
            .map { email, password -> Credentials? in
                guard let email = email, let password = password else {
                    return nil
                }
                return Credentials(email: email, password: password)
            }
        let credentialsProperty = Property<Credentials?>(initial: nil, then: credentials)
        let signUpAction = Action<Void, Void, NoError>(unwrapping: credentialsProperty, execute: makeSignUpTask)
        self.signUpAction = ActionViewModel(action: signUpAction)
    }

    fileprivate let title: String
    fileprivate let backTitle: String
    fileprivate let backSink: () -> Void
    fileprivate let passwordPlaceholder: String
    fileprivate let passwordSink: (String?) -> Void
    fileprivate let email: EmailField
    fileprivate let signUpTitle: String
    fileprivate let signUpAction: ActionViewModel

    private let backPipe = Signal<Void, NoError>.pipe()
    private let passwordPipe = Signal<String?, NoError>.pipe()

    deinit {
        self.backPipe.input.sendInterrupted()
        self.passwordPipe.input.sendInterrupted()
    }
}

extension SignUpScreen: Presentable {

    var present: (SignUpScreenPresenters) -> Disposable? {
        return { [weak self] presenters in
            guard let someSelf = self else { return nil }
            let disposable = CompositeDisposable()
            disposable += presenters.title.present(someSelf.title)
            disposable += presenters.backTitle.present(someSelf.backTitle)
            disposable += presenters.backSink.present(someSelf.backSink)
            disposable += presenters.passwordPlaceholder.present(someSelf.passwordPlaceholder)
            disposable += presenters.passwordSink.present(someSelf.passwordSink)
            disposable += presenters.email.present(someSelf.email)
            disposable += presenters.signUpTitle.present(someSelf.signUpTitle)
            disposable += presenters.signUpAction.present(someSelf.signUpAction)
            return disposable
        }
    }
}

private typealias Credentials = (email: String, password: String)

private func makeSignUpTask(credentials: Credentials) -> SignalProducer<Void, NoError> {
    print("🚨 Singned Up! Email: \(credentials.email), Password: \(credentials.password)")
    return .empty
}
