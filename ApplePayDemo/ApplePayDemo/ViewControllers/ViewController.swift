//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by User on 08.09.2021.
//

import UIKit
import PassKit

class ViewController: UIViewController {

    @IBOutlet private weak var paymentStatusLabel: UILabel!

    private let priceString = "Price"
    private let kommissionString = "Kommission"

    private let applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupApplePayButton()
        paymentStatusLabel.isHidden = true
    }

    private func setupApplePayButton() {
        view.addSubview(applePayButton)

        applePayButton.translatesAutoresizingMaskIntoConstraints = false

        let xConstraint = NSLayoutConstraint(item: applePayButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)

        let yConstraint = NSLayoutConstraint(item: applePayButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: applePayButton, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)

        let heightConstraint = NSLayoutConstraint(item: applePayButton, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)

        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])

        applePayButton.addTarget(self, action: #selector(presentPaymentVC), for: .touchUpInside)
    }

    @objc func presentPaymentVC() {
        let poductInfo = Product.shared
        let product = PKPaymentSummaryItem(label: priceString, amount: poductInfo.price)
        let shippingMethod = PKShippingMethod(label: kommissionString, amount: poductInfo.kommission)
        let summary = PKPaymentSummaryItem(label: poductInfo.productName, amount: NSDecimalNumber(decimal: (poductInfo.price as Decimal) + (poductInfo.kommission as Decimal)))

        let request = PKPaymentRequest()
        request.currencyCode = poductInfo.currency
        request.countryCode = "UA"
        request.merchantIdentifier = "applePayDemo.com"

        request.merchantCapabilities = .capability3DS
        request.supportedNetworks = [.visa, .masterCard]
        request.paymentSummaryItems = [product, shippingMethod, summary]

        request.shippingType = .shipping
        request.requiredShippingContactFields = [.postalAddress, .name, .phoneNumber, .emailAddress]
        request.shippingContact = createContact()

        guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else { return }
        paymentVC.delegate = self

        present(paymentVC, animated: true)
    }

    private func createContact() -> PKContact {
         let userInfo = UserInfo.shared
         let contact = PKContact()

         contact.emailAddress = userInfo.email
         contact.phoneNumber = CNPhoneNumber(stringValue: userInfo.phoneNumber)

         var name = PersonNameComponents()
         name.givenName = userInfo.name
         contact.name = name

         let address = CNMutablePostalAddress()
         address.street = userInfo.address
         contact.postalAddress = address

         return contact
     }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate
extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: {
            self.applePayButton.isHidden = false
            self.paymentStatusLabel.isHidden = true
        })
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        applePayButton.isUserInteractionEnabled = false
        paymentStatusLabel.isHidden = false

        controller.dismiss(animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.applePayButton.isUserInteractionEnabled = true
                self.paymentStatusLabel.isHidden = true
            }
        })
    }
}

