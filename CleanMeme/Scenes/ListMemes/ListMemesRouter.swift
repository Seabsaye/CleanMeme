//
//  ListMemesRouter.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

@objc protocol ListMemesRoutingLogic {
    func routeToShowMeme(segue: UIStoryboardSegue?)
    func routeToCreateMeme(segue: UIStoryboardSegue?)
}

protocol ListMemesDataPassing {
    var dataStore: ListMemesDataStore? { get }
}

class ListMemesRouter: NSObject, ListMemesRoutingLogic, ListMemesDataPassing {
    weak var viewController: ListMemesViewController?
    var dataStore: ListMemesDataStore?

    // MARK: Routing

    func routeToShowMeme(segue: UIStoryboardSegue?) {
        var destinationVC: ShowMemeViewController

        if let segue = segue {
            destinationVC = segue.destination as! ShowMemeViewController

        } else {
            destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "ShowMemeViewController") as! ShowMemeViewController
        }

        var destinationDS = destinationVC.router!.dataStore!

        passDataToShowMeme(source: dataStore!, destination: &destinationDS)
        navigateToShowMeme(source: viewController!, destination: destinationVC)
    }

    func routeToCreateMeme(segue: UIStoryboardSegue?) {
        let destinationVC = segue != nil ? segue!.destination as! AddMemeViewController : viewController?.storyboard?.instantiateViewController(withIdentifier: "AddMemeViewController") as! AddMemeViewController
        var destinationDS = destinationVC.router!.dataStore!

        passDataToAddMeme(source: dataStore!, destination: &destinationDS)
        navigateToAddMeme(source: viewController!, destination: destinationVC)
    }

    // MARK: Navigation

    func navigateToShowMeme(source: ListMemesViewController, destination: ShowMemeViewController) {
        // not needed, handled by segue
    }

    func navigateToAddMeme(source: ListMemesViewController, destination: AddMemeViewController) {
        // not needed, handled by segue
    }

    // MARK: Passing data

    func passDataToShowMeme(source: ListMemesDataStore, destination: inout ShowMemeDataStore) {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination.meme = source.memes?[selectedRow!]
    }

    func passDataToAddMeme(source: ListMemesDataStore, destination: inout AddMemeDataStore) {
        // nothing to pass
    }
}
