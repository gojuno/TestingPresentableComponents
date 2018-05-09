//
//  ActionMock.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

final class ActionMock<Input, Value, Error: Swift.Error> {

    typealias Task = SignalProducer<Value, Error>
    typealias Action = ReactiveSwift.Action<Input, Value, Error>

    let inputs = MutableProperty<[Input]>([])
    let pipe = Signal<Signal<Value, Error>.Event, NoError>.pipe()
    let action: Action

    init() {
        self.action = Action { [inputs, pipe] input in
            inputs.value.append(input)
            return SignalProducer(pipe.output).dematerialize()
        }
    }

    deinit {
        self.pipe.1.sendCompleted()
    }
}

extension ActionMock {

    var input: Input! {
        return self.inputs.value.last!
    }

    var inputsCount: Int {
        return self.inputs.value.count
    }

    func receive(_ value: Value) {
        self.pipe.input.send(value: .value(value))
        self.pipe.input.send(value: .completed)
    }

    func receive(_ error: Error) {
        self.pipe.input.send(value: .failed(error))
    }
}
