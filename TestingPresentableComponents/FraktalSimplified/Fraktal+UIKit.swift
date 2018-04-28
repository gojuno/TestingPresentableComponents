//
//  Fraktal+UIKit.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation
import UIKit

import ReactiveSwift

extension UILabel {

    var textPresenter: Presenter<String?> {
        return Presenter { [weak self] value -> Disposable? in
            self?.text = value
            return nil
        }
    }
}
