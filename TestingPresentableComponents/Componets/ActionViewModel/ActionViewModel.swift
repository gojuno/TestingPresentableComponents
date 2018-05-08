//
//  ActionViewModel.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

final class ActionViewModel {

    init(action: Action<Void, Void, NoError>) {
        self.action = action

        let disposable = self.executionIntents.output.producer
            .filter { action.isEnabled.value }
            .flatMap(.latest) { action.apply() }
            .flatMapError { _ -> SignalProducer<Void, NoError> in
                assertionFailure()
                return .empty
            }
            .start()

        self.disposable = ScopedDisposable(disposable)
        self.simpleAction = self.executionIntents.input.send
        self.executing = self.action.isExecuting
        self.enabled = self.action.isEnabled
    }

    fileprivate let simpleAction: () -> Void
    fileprivate let executing: Property<Bool>
    fileprivate let enabled: Property<Bool>

    private let action: Action<Void, Void, NoError>
    private let executionIntents = Signal<Void, NoError>.pipe()
    private let disposable: ScopedDisposable<AnyDisposable>

    deinit {
        self.executionIntents.1.sendInterrupted()
    }
}

extension ActionViewModel: Presentable {

    var present: (ActionViewModelPresenters) -> Disposable? {
        return { [weak self] presenters in
            guard let someSelf = self else { return nil }
            let disposable = CompositeDisposable()
            disposable += presenters.simpleAction.present(someSelf.simpleAction)
            disposable += presenters.executing.present(someSelf.executing.producer)
            disposable += presenters.enabled.present(someSelf.enabled.producer)
            return disposable
        }
    }
}
