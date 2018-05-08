//
//  SignalProducer+TestUtils.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift

final class SignalProducerHistory<Value, Error: Swift.Error> {
    fileprivate(set) var starting = false
    fileprivate(set) var started = false
    fileprivate(set) var events: [Signal<Value, Error>.Event] = []
    fileprivate(set) var failure: Error?
    fileprivate(set) var completed = false
    fileprivate(set) var interrupted = false
    fileprivate(set) var terminated = false
    fileprivate(set) var disposed = false
    fileprivate(set) var values: [Value] = []

    init() {}
}

extension SignalProducer {
    typealias History = SignalProducerHistory<Value, Error>
}

extension SignalProducer {

    func saveHistoryTo(_ history: SignalProducerHistory<Value, Error>) -> SignalProducer {
        return self.on(
            starting: { history.starting = true },
            started: { history.started = true },
            event: { history.events.append($0) },
            failed: { history.failure = $0 },
            completed: { history.completed = true },
            interrupted: { history.interrupted = true },
            terminated: { history.terminated = true },
            disposed: { history.disposed = true },
            value: { history.values.append($0) }
        )
    }
}
