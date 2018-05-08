//
//  UIButton.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation
import UIKit

import ReactiveSwift

extension UIButton {
    
    var simpleActionPresenter: Presenter<() -> Void> {
        return Presenter.UI { [weak self] action in
            guard let someSelf = self else { return nil }
            let target = Target {
                if someSelf.isEnabled { action() }
            }
            someSelf.addTarget(target, action: Target.ActionSelector, for: .touchUpInside)
            return ScopedDisposable(AnyDisposable {
                someSelf.removeTarget(target, action: Target.ActionSelector, for: .touchUpInside)
            })
        }
    }

    var actionViewModelPresenter: Presenter<AnyPresentable<ActionViewModelPresenters>> {
        return Presenter.UI { [weak self] presentable in
            guard let someSelf = self else { return nil }
            return presentable.present(ActionViewModelPresenters(
                simpleAction: someSelf.simpleActionPresenter,
                executing: Presenter.UI { _ in nil },
                enabled: someSelf.enabledPresenter
            ))
        }
    }

    var titlePresenter: Presenter<String> {
        return Presenter.UI { [weak self] in
            self?.setTitle($0, for: .normal)
            return nil
        }
    }

    var enabledPresenter: Presenter<Bool> {
        return Presenter.UI { [weak self] in
            self?.isEnabled = $0
            return nil
        }
    }
}

class Target: NSObject {

    static var ActionSelector = #selector(performAction)

    init(action: @escaping () -> Void) {
        self.action = action
        super.init()
    }

    private let action: () -> Void
    @objc func performAction() { self.action() }
}

struct ActionViewModelPresenters {
    let simpleAction: Presenter<() -> Void>
    let executing: Presenter<Bool>
    let enabled: Presenter<Bool>
}
