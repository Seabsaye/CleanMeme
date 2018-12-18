//
//  ShowMemeViewController.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol ShowMemeDisplayLogic: class {
    func displayMeme(viewModel: ShowMeme.GetMeme.ViewModel)
}

class ShowMemeViewController: UIViewController {
    var interactor: ShowMemeBusinessLogic?
    var router: (NSObject & ShowMemeRoutingLogic & ShowMemeDataPassing)?

    @IBOutlet weak var memeTitle: UILabel!
    @IBOutlet weak var memeUrl: UILabel!
    @IBOutlet weak var memeImage: UIImageView!

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
        let interactor = ShowMemeInteractor()
        let presenter = ShowMemePresenter()
        let router = ShowMemeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrder()
    }

    // MARK: - Get order

    func getOrder() {
        let request = ShowMeme.GetMeme.Request()
        interactor?.getMeme(request: request)
    }
}

extension ShowMemeViewController: ShowMemeDisplayLogic {
    func displayMeme(viewModel: ShowMeme.GetMeme.ViewModel) {
        let displayedMeme = viewModel.displayedMeme
        memeTitle.text = displayedMeme.name
        memeUrl.text = displayedMeme.url
        memeImage.image = displayedMeme.image
    }
}
