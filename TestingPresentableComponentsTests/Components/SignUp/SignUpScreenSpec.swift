//
//  SignUpScreenSpec.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Quick
import Nimble

import ReactiveSwift
import enum Result.NoError

@testable import TestingPresentableComponents

final class SignUpScreenSpec: QuickSpec {

    override func spec() {

        describe("SignUpScreen") {

            typealias SUT = SignUpScreen

            var sut: SUT!
            var view: SUT.TestView!
            var resultHistory: SignalProducer<SUT.Result, NoError>.History!
            var disposable: Disposable!

            beforeEach {
                sut = SUT()
                view = SUT.TestView((AnyPresentable(sut)))
                resultHistory = SignalProducer<SUT.Result, NoError>.History()
                disposable = sut.result.producer.saveHistoryTo(resultHistory).start()
            }

            afterEach {
                disposable.dispose()
                disposable = nil
                resultHistory = nil
                sut = nil
                view = nil
            }

            it("presents correct titles") {
                expect(view.title) == "Sign Up"
                expect(view.backTitle) == "Back"
                expect(view.passwordPlaceholder) == "Password"
            }

            it("does not have any result") {
                expect(resultHistory.values.count) == 0
            }

            describe("when a user taps the back button") {

                beforeEach {
                    view.backSink()
                }

                it("has 'back' result") {
                    expect(resultHistory.values) == [.back]
                }
            }
        }
    }
}

