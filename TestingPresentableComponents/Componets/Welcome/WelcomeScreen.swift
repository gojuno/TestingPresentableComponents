//
//  WelcomeScreen.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

final class WelcomeScreen {

    init() {
        self.title = "Welcome"
        self.signUpTitle = "Sign Up"

        let showSignUp = Action<Void, Void, NoError>.echo()
        self.signUpAction = ActionViewModel(action: showSignUp)

        let signUpScreen = showSignUp.values.producer
            .flatMap(.latest) { (_) -> SignalProducer<SignUpScreen?, NoError> in
                let screen = SignUpScreen()
                return screen.result.producer
                    .filter { $0.isBack }
                    .map { _ in nil }
                    .take(first: 1)
                    .prefix(value: screen)
            }
        self.signUpScreen = Property(initial: nil, then: signUpScreen)
    }

    fileprivate let title: String
    fileprivate let signUpTitle: String
    fileprivate let signUpAction: ActionViewModel
    fileprivate let signUpScreen: Property<SignUpScreen?>
}

extension WelcomeScreen: Presentable {

    var present: (WelcomeScreenPresenters) -> Disposable? {
        return { [weak self] presenters in
            guard let someSelf = self else { return nil }
            let disposable = CompositeDisposable()
            disposable += presenters.title.present(someSelf.title)
            disposable += presenters.signUpTitle.present(someSelf.signUpTitle)
            disposable += presenters.signUpAction.present(someSelf.signUpAction)
            disposable += presenters.signUpScreen.present(someSelf.signUpScreen.producer.map { $0.map(AnyPresentable.init) })
            return disposable
        }
    }
}

extension Action where Input == Output, Error == NoError {
    static func echo() -> Action {
        return Action { SignalProducer(value: $0) }
    }
}

private extension SignUpScreen.Result {
    var isBack: Bool {
        switch self {
        case .back: return true
        }
    }
}
