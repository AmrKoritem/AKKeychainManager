//
//  ViewController.swift
//  Example
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKKeychainManager

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    @IBAction func save() {
        do {
            let _ = try AKKeychainManager.shared.load(service: "test", account: "test")
            try AKKeychainManager.shared.update(service: "test", account: "test", value: textField.text ?? "")
            showError("")
        } catch {
            guard let kError = error as? KeychainError else {
                showError(error.localizedDescription)
                return
            }
            switch kError {
            case .loadFailed:
                saveData()
            default:
                showError(kError.localizedDescription)
            }
        }
    }

    @IBAction func show() {
        do {
            let savedData = try AKKeychainManager.shared.load(service: "test", account: "test")
            label.text = savedData
            showError("")
        } catch {
            showError(error.localizedDescription)
        }
    }

    func showError(_ error: String) {
        errorLabel.text = error
    }

    func saveData() {
        do {
            try AKKeychainManager.shared.save(service: "test", account: "test", value: textField.text ?? "")
            showError("")
        } catch {
            showError(error.localizedDescription)
        }
    }
}
