//
//  FraktalSimplified.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

protocol Presentable: class {
    associatedtype Presenters
    var present: (Presenters) -> Disposable? { get }
}

struct Presenter<ViewModel> {

    init(_ bind: @escaping (ViewModel) -> Disposable?) {
        self.bind = bind
    }

    func present(_ viewModel: ViewModel) -> Disposable? {
        return self.bind(viewModel)
    }

    private let bind: (ViewModel) -> Disposable?
}

extension Presenter {

    func present(_ producer: SignalProducer<ViewModel, NoError>) -> Disposable? {
        let compositeDisposable = CompositeDisposable()
        let serialDisposable = SerialDisposable()

        compositeDisposable += serialDisposable
        compositeDisposable += producer.startWithValues { value in
            serialDisposable.inner?.dispose()
            serialDisposable.inner = self.present(value)
        }

        return ScopedDisposable(compositeDisposable)
    }
}
