//
//  PresentedValue.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift

final class PresentedValue<T> {

    let value: T
    let presentedAt = PresentedTime.tick()

    let disposable = CompositeDisposable()
    private(set) var disposedAt: UInt64?

    init(value: T) {
        self.value = value
        self.disposable += AnyDisposable { [weak self] in
            self?.disposedAt = PresentedTime.tick()
        }
    }
}

extension PresentedValue: CustomDebugStringConvertible {
    var debugDescription: String {
        return "<\(type(of: self)): value=\(value), presented=\(presentedAt), disposed=\(String(describing: disposedAt))>"
    }
}

private struct PresentedTime {
    static var time = UInt64(0)
    static func tick() -> UInt64 {
        time += 1
        return time
    }
}
