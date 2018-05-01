//
//  RootStory+TestView.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift

@testable import TestingPresentableComponents

extension RootStory {

    final class TestView: TestViewType {

        let _title = AnyTestView<String>.Optional.View()

        let disposable: ScopedDisposable<AnyDisposable>?

        init(_ viewModel: AnyPresentable<RootStoryPresenters>) {
            self.disposable = viewModel.present(RootStoryPresenters(
                title: self._title.presenter
            )).map(ScopedDisposable.init)
        }
    }
}

extension RootStory.TestView {
    var title: String! { return _title.last?.view?.value }
}
