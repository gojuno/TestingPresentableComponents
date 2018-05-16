//
//  TestApp.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

@testable import TestingPresentableComponents
import FraktalSimplified
import FraktalSimplifiedTestUtils

final class TestApp {

    let view: WelcomeScreen.TestView

    init() {
        // Inject your mock dependencies here
        self.root = WelcomeScreen()
        self.view = WelcomeScreen.TestView(AnyPresentable(self.root))
    }

    private let root: WelcomeScreen
}

extension TestApp {

    func openSignUp() {
        self.view.signUpAction.simpleAction()
    }

    func signUp() {
        self.openSignUp()
        self.view.signUpScreen.email.sink("some@email.com")
        self.view.signUpScreen.passwordSink("123456")
        self.view.signUpAction.simpleAction()
    }
}
