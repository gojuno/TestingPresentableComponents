//
//  RootStory.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

final class RootStory {

    init() {
        self.title = SignalProducer(value: "Some Title")
    }

    private let title: SignalProducer<String?, NoError>
}

extension RootStory: Presentable {
    var present: (RootStoryPresenters) -> Disposable? {
        return { [weak self] presenters in
            guard let someSelf = self else { return nil }
            let disposable = CompositeDisposable()
            disposable += presenters.title.present(someSelf.title)
            return disposable
        }
    }
}
