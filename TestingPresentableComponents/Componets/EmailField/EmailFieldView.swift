//
//  EmailFieldView.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation
import UIKit

struct EmailFieldPresenters {
    let placeholder: Presenter<String>
    let sink: Presenter<(String?) -> Void>
}

extension UITextField {
    var emailPresenter: Presenter<AnyPresentable<EmailFieldPresenters>> {
        return Presenter.UI { [weak self] presentable in
            guard let someSelf = self else { return nil }
            return presentable.present(EmailFieldPresenters(
                placeholder: someSelf.placeholderPresenter,
                sink: someSelf.textSinkPresenter
            ))
        }
    }
}
