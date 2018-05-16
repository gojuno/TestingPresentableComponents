//
//  EmailField+TestView.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import FraktalSimplified
import FraktalSimplifiedTestUtils

@testable import TestingPresentableComponents

extension EmailField {

    final class TestView: TestViewType {

        let _placeholder = AnyTestView<String>.View()
        let _sink = AnyTestView<(String?) -> Void>.View()

        let disposable: ScopedDisposable<AnyDisposable>?

        init(_ viewModel: AnyPresentable<EmailFieldPresenters>) {
            self.disposable = viewModel.present(EmailFieldPresenters(
                placeholder: self._placeholder.presenter,
                sink: self._sink.presenter
            )).map(ScopedDisposable.init)
        }
    }
}

extension EmailField.TestView {
    var placeholder: String! { return self._placeholder.last?.value }
    var sink: ((String?) -> Void)! { return self._sink.last?.value }
}
