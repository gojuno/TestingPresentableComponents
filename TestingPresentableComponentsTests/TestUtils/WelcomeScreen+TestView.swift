//
//  WelcomeScreen+TestView.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import FraktalSimplified
import FraktalSimplifiedTestUtils

@testable import TestingPresentableComponents

extension WelcomeScreen {

    final class TestView: TestViewType {

        let _title = AnyTestView<String>.View()
        let _signUpTitle = AnyTestView<String>.View()
        let _signUpAction = ActionViewModel.TestView.View()
        let _signUpScreen = SignUpScreen.TestView.Optional.View()

        let disposable: ScopedDisposable<AnyDisposable>?

        init(_ viewModel: AnyPresentable<WelcomeScreenPresenters>) {
            self.disposable = viewModel.present(WelcomeScreenPresenters(
                title: self._title.presenter,
                signUpTitle: self._signUpTitle.presenter,
                signUpAction: self._signUpAction.presenter,
                signUpScreen: self._signUpScreen.presenter
            )).map(ScopedDisposable.init)
        }
    }
}

extension WelcomeScreen.TestView {
    var title: String! { return self._title.last?.value }
    var signUpTitle: String! { return self._signUpTitle.last?.value }
    var signUpAction: ActionViewModel.TestView! { return self._signUpAction.last }
    var signUpScreen: SignUpScreen.TestView! { return self._signUpScreen.last?.view }
}
