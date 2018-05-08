//
//  SignUpScreen.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
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
    }

    fileprivate let title: String
    fileprivate let backTitle: String
    fileprivate let backSink: () -> Void
    fileprivate let passwordPlaceholder: String
    fileprivate let passwordSink: (String?) -> Void
    fileprivate let email: EmailField

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
            return disposable
        }
    }
}
