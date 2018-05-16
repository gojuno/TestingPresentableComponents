//
//  SignUpViewController.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import Foundation
import UIKit
import FraktalSimplified

struct SignUpScreenPresenters {
    let title: Presenter<String>
    let backTitle: Presenter<String>
    let backSink: Presenter<() -> Void>
    let passwordPlaceholder: Presenter<String>
    let passwordSink: Presenter<(String?) -> Void>
    let email: Presenter<AnyPresentable<EmailFieldPresenters>>
    let signUpTitle: Presenter<String>
    let signUpAction: Presenter<AnyPresentable<ActionViewModelPresenters>>
}

final class SignUpViewController: UIViewController {

    static func create() -> SignUpViewController {
        let vc = SignUpViewController()
        vc.loadViewIfNeeded()
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.view.addSubview(self.backButton)

        let container = UIStackView(
            arrangedSubviews: [
                self.titleLabel,
                self.emailField,
                self.passwordField,
                self.signUpButton
            ]
        )
        container.axis = .vertical
        container.spacing = 24
        self.view.addSubview(container)

        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.backButton.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -16),
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 16)
        ])
    }
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    fileprivate let backButton = UIButton(type: .system)
    fileprivate let emailField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    fileprivate let passwordField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    fileprivate let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        return button
    }()

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
                email: someSelf.emailField.emailPresenter,
                signUpTitle: someSelf.signUpButton.titlePresenter,
                signUpAction: someSelf.signUpButton.actionViewModelPresenter
            ))
        }
    }
}
