//
//  EmailFieldSpec.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import Quick
import Nimble
import FraktalSimplified
import FraktalSimplifiedTestUtils

@testable import TestingPresentableComponents

final class EmailFieldSpec: QuickSpec {

    override func spec() {

        describe("EmailField") {

            typealias SUT = EmailField

            var sut: SUT!
            var view: SUT.TestView!

            beforeEach {
                sut = SUT()
                view = SUT.TestView((AnyPresentable(sut)))
            }

            afterEach {
                sut = nil
                view = nil
            }

            it("presents a correct placeholder") {
                expect(view.placeholder) == "Email"
            }

            it("has an invalid result") {
                expect(sut.result.value) == .invalid(nil)
            }

            describe("when a user enters an invalid email") {

                let invalidEmail = "invalid_email"

                beforeEach {
                    view.sink(invalidEmail)
                }

                it("has an invalid result") {
                    expect(sut.result.value) == .invalid(invalidEmail)
                }
            }

            describe("when a user enters a valid email") {

                let validEmail = "some@email.com"

                beforeEach {
                    view.sink(validEmail)
                }

                it("has a valid result") {
                    expect(sut.result.value) == .valid(validEmail)
                }

                describe("when a user enters an invalid email") {

                    let invalidEmail = "some@emailcom"

                    beforeEach {
                        view.sink(invalidEmail)
                    }

                    it("has a valid result") {
                        expect(sut.result.value) == .invalid(invalidEmail)
                    }
                }
            }
        }
    }
}
