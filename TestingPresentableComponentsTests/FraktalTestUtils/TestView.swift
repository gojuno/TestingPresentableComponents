//
//  TestView.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift

@testable import TestingPresentableComponents

protocol TestViewType {
    associatedtype ViewModel
    init(_ viewModel: ViewModel)
    var disposable: ScopedDisposable<AnyDisposable>? { get }
}

protocol TestPresenterProtocol {
    associatedtype TestView: TestViewType
    var presenter: Presenter<TestView.ViewModel> { get }
    var presented: [PresentedValue<TestView>] { get }
}

extension TestPresenterProtocol {
    public var last: TestView! { return self.presented.last?.value }
}

final class TestPresenter<TestView: TestViewType>: TestPresenterProtocol {

    init() {}

    var presenter: Presenter<TestView.ViewModel> {
        return Presenter.Test { [weak self] presentable in
            let view = TestView(presentable)
            let presentedValue = PresentedValue(value: view)
            presentedValue.disposable += presentedValue.value.disposable
            self!.presented.append(presentedValue)
            return presentedValue.disposable
        }
    }

    private(set) var presented: [PresentedValue<TestView>] = []
}

extension TestViewType {
    // TODO: Consider using 'TestPresenter' name
    typealias View = TestPresenter<Self>
}

final class OptionalTestView<WrappedTestView: TestViewType>: TestViewType {

    let view: WrappedTestView?

    var disposable: ScopedDisposable<AnyDisposable>? {
        return self.view?.disposable
    }

    init(_ viewModel: WrappedTestView.ViewModel?) {
        self.view = viewModel.map(WrappedTestView.init)
    }
}

extension TestViewType {
    typealias Optional = OptionalTestView<Self>
}

final class AnyTestView<Value>: TestViewType {

    let value: Value
    var disposable: ScopedDisposable<AnyDisposable>? { return nil }

    init(_ viewModel: Value) {
        self.value = viewModel
    }
}
