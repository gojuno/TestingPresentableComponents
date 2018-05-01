//
//  UITextField.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation
import UIKit

import ReactiveSwift

extension UITextField {

    var textSinkPresenter: Presenter<(String?) -> Void> {
        return Presenter.UI { [weak self] sink in
            guard let someSelf = self else { return nil }
            let didChangeObserver = someSelf.createDidChangeObserver(with: sink)
            return AnyDisposable {
                NotificationCenter.default.removeObserver(didChangeObserver)
            }
        }
    }

    var placeholderPresenter: Presenter<String> {
        return Presenter.UI { [weak self] string in
            guard let someSelf = self else { return nil }
            someSelf.placeholder = string
            return nil
        }
    }

    private func createDidChangeObserver(with handler: @escaping (String?) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default
            .addObserver(
                forName: NSNotification.Name.UITextFieldTextDidChange,
                object: self,
                queue: nil,
                using: { [weak self] _ in
                    guard let someSelf = self else { assertionFailure(); return }
                    handler(someSelf.text)
                }
        )
    }
}
