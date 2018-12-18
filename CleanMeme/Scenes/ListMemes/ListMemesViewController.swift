//
//  ListMemesViewController.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol ListMemesDisplayLogic: class {
    func displayFetchedMemes(viewModel: ListMemes.FetchMemes.ViewModel)
}

class ListMemesViewController: UITableViewController, ListMemesDisplayLogic {
    var interactor: ListMemesBusinessLogic?
    var router: (NSObjectProtocol & ListMemesRoutingLogic & ListMemesDataPassing)?
    var displayedMemes: [ListMemes.FetchMemes.ViewModel.DisplayedMeme] = []

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
        let interactor = ListMemesInteractor()
        let presenter = ListMemesPresenter()
        let router = ListMemesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MemeTableViewCell", bundle: nil), forCellReuseIdentifier: "MemeTableViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMemes()
    }

    // MARK: - Fetch Memes

    func fetchMemes() {
        let request = ListMemes.FetchMemes.Request()
        interactor?.fetchMemes(request: request)
    }

    func displayFetchedMemes(viewModel: ListMemes.FetchMemes.ViewModel) {
        displayedMemes = viewModel.displayedMemes
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedMemes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayedMeme = displayedMemes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as? MemeTableViewCell else { return MemeTableViewCell() }

        cell.memeTitle.text = displayedMeme.name
        cell.memeUrl.text = displayedMeme.url
        cell.memeImageView.image = displayedMeme.image

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMeme", sender: indexPath.row)
    }
}
