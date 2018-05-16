//
//  ActionViewModel+TestView.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import Quick
import Nimble
import ReactiveSwift
import FraktalSimplified
import FraktalSimplifiedTestUtils

@testable import TestingPresentableComponents

extension ActionViewModel {

    final class TestView: TestViewType {

        let _simpleAction = AnyTestView<() -> Void>.View()
        let _executing = AnyTestView<Bool>.View()
        let _enabled = AnyTestView<Bool>.View()

        var disposable: ScopedDisposable<AnyDisposable>?

        init(_ viewModel: AnyPresentable<ActionViewModelPresenters>) {
            self.disposable = viewModel.present(ActionViewModelPresenters(
                simpleAction: self._simpleAction.presenter,
                executing: self._executing.presenter,
                enabled: self._enabled.presenter
            )).map(ScopedDisposable.init)
        }
    }
}

extension ActionViewModel.TestView {
    var simpleAction: (() -> Void)! { return self._simpleAction.last?.value }
    var executing: Bool! { return self._executing.last?.value }
    var enabled: Bool! { return self._enabled.last?.value }
}
