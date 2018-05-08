//
//  WelcomeViewController.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation
import UIKit

import ReactiveSwift

struct WelcomeScreenPresenters {
    let title: Presenter<String>
    let signUpTitle: Presenter<String>
    let signUpAction: Presenter<AnyPresentable<ActionViewModelPresenters>>
    let signUpScreen: Presenter<AnyPresentable<SignUpScreenPresenters>?>
}

final class WelcomeViewController: UIViewController {

    static func create() -> WelcomeViewController {
        let vc = WelcomeViewController()
        vc.loadViewIfNeeded()
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [self.titleLabel, self.signUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 16),
            self.signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signUpButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 16),
            self.signUpButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    fileprivate let titleLabel = UILabel()
    fileprivate let signUpButton = UIButton()

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}

extension WelcomeViewController {
    var presenter: Presenter<AnyPresentable<WelcomeScreenPresenters>> {
        return Presenter.UI { [weak self] presentable in
            guard let someSelf = self else { return nil }
            return presentable.present(WelcomeScreenPresenters(
                title: someSelf.titleLabel.textPresenter,
                signUpTitle: someSelf.signUpButton.titlePresenter,
                signUpAction: someSelf.signUpButton.actionViewModelPresenter,
                signUpScreen: someSelf.signUpScreenPresenter
            ))
        }
    }
}

extension UIViewController {
    var signUpScreenPresenter: Presenter<AnyPresentable<SignUpScreenPresenters>?> {
        return Presenter.UI { [weak self] presentable in
            guard let someSelf = self else { return nil }
            switch presentable {
            case let .some(presentable):
                let vc = SignUpViewController.create()
                let disposable = CompositeDisposable()
                disposable += vc.presenter.present(presentable)
                disposable += AnyDisposable { someSelf.dismiss(animated: true, completion: nil) }
                someSelf.present(vc, animated: true, completion: nil)
                return disposable
            case .none:
                return nil
            }
        }
    }
}
