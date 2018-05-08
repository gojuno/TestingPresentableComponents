//
//  SignUpViewController.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation
import UIKit

struct SignUpScreenPresenters {
    let title: Presenter<String>
    let backTitle: Presenter<String>
    let backSink: Presenter<() -> Void>
    let passwordPlaceholder: Presenter<String>
    let passwordSink: Presenter<(String?) -> Void>
    let email: Presenter<AnyPresentable<EmailFieldPresenters>>
}

final class SignUpViewController: UIViewController {

    static func create() -> SignUpViewController {
        let vc = SignUpViewController()
        vc.loadViewIfNeeded()
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.backButton)

        let container = UIStackView(
            arrangedSubviews: [
                self.titleLabel,
                self.emailField,
                self.passwordField
            ]
        )
        container.axis = .vertical
        container.alignment = .leading
        container.spacing = 16
        self.view.addSubview(container)

        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.backButton.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -16),
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            container.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 16),
            container.topAnchor.constraint(greaterThanOrEqualTo: self.backButton.bottomAnchor, constant: 16)
        ])

        self.emailField.setContentCompressionResistancePriority(.init(750), for: .vertical)
        self.passwordField.setContentCompressionResistancePriority(.init(749), for: .vertical)
        self.titleLabel.setContentCompressionResistancePriority(.init(748), for: .vertical)
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let backButton = UIButton()
    fileprivate let emailField = UITextField()
    fileprivate let passwordField = UITextField()

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}

extension SignUpViewController {

    var presenter: Presenter<AnyPresentable<SignUpScreenPresenters>> {
        return Presenter.UI { [weak self] presentable in
            guard let someSelf = self else { return nil }
            return presentable.present(SignUpScreenPresenters(
                title: someSelf.titleLabel.textPresenter,
                backTitle: someSelf.backButton.titlePresenter,
                backSink: someSelf.backButton.simpleActionPresenter,
                passwordPlaceholder: someSelf.passwordField.placeholderPresenter,
                passwordSink: someSelf.passwordField.textSinkPresenter,
                email: someSelf.emailField.emailPresenter
            ))
        }
    }
}
