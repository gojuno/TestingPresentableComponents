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

    func present(_ viewModel: ViewModel) -> Disposable? {
        return self.bind(viewModel)
    }

    fileprivate init(_ bind: @escaping (ViewModel) -> Disposable?) {
        self.bind = bind
    }

    private let bind: (ViewModel) -> Disposable?
}

extension Presenter {

    static func UI(bind: @escaping (ViewModel) -> Disposable?) -> Presenter {
        return Presenter { viewModel -> Disposable? in

            let scheduler = UIScheduler()
            let disposable = CompositeDisposable()

            // TODO: Can we ignore disposable here?
            scheduler.schedule {
                disposable += bind(viewModel)
            }

            return AnyDisposable {
                // TODO: Can we ignore disposable here?
                scheduler.schedule(disposable.dispose)
            }
        }
    }

    static func Test(bind: @escaping (ViewModel) -> Disposable?) -> Presenter {
        if NSClassFromString("XCTestCase") == nil {
            assertionFailure()
            return Presenter { _ in nil }
        }
        return Presenter(bind)
    }
}

extension Presenter {

    /// Present SignalProducer of ViewModel
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

    /// Present any Presentable with same Presenters
    func present<T: Presentable>(_ presentable: T) -> Disposable?
    where ViewModel == AnyPresentable<T.Presenters> {
        return self.present(ViewModel(presentable))
    }
}

final class AnyPresentable<Presenters>: Presentable {

    let present: (Presenters) -> Disposable?

    init<T: Presentable>(_ presentable: T) where T.Presenters == Presenters {
        self.present = presentable.present
    }
}
