//
//  RootStorySpec.swift
//  TestingPresentableComponentsTests
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import TestingPresentableComponents

final class RootStorySpec: QuickSpec {

    override func spec() {

        describe("RootStory") {

            typealias SUT = RootStory

            var sut: SUT!
            var view: SUT.TestView!

            beforeEach {
                sut = SUT()
                view = SUT.TestView(AnyPresentable(sut))
            }

            afterEach {
                sut = nil
                view = nil
            }

            it("show a correct title") {
                expect(view.title) == "Some Title"
            }
        }
    }
}
