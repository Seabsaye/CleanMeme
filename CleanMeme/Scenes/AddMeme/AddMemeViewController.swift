//
//  AddMemeViewController.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol AddMemeDisplayLogic: class {

}

class AddMemeViewController: UIViewController {
    var interactor: AddMemeInteractor?
    var router: (NSObjectProtocol & AddMemeRoutingLogic & AddMemeDataPassing)?

    var imagePickerController: UIImagePickerController!

    @IBOutlet weak var memeNameTextField: UITextField!
    @IBOutlet weak var memeUrlTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = AddMemeInteractor()
        let presenter = AddMemePresenter()
        let router = AddMemeRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePickerController.delegate = self
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        memeNameTextField.delegate = self
        memeUrlTextField.delegate = self
        memeImageView.contentMode = .scaleAspectFit
    }

    @IBAction func uploadMemeButtonTapped(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let memeName = memeNameTextField.text,
            let memeUrl = memeUrlTextField.text,
            let memeImage = memeImageView.image,
            !memeName.isEmpty,
            !memeUrl.isEmpty else { return }

        let request = AddMeme.Request(memeFormFields: AddMeme.MemeFormFields(memeName: memeName, memeUrl: memeUrl, memeImage: memeImage))
        interactor?.addMeme(request: request)
    }
}

// MARK: AddMemeDisplayLogic
extension AddMemeViewController: AddMemeDisplayLogic {

}

// MARK: UIImagePickerControllerDelegate
extension AddMemeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        memeImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate
extension AddMemeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == memeNameTextField { memeUrlTextField.becomeFirstResponder() }
        return true
    }
}

// MARK: UINavigationControllerDelegate
extension AddMemeViewController: UINavigationControllerDelegate { }
