//
//  AddMemeRouter.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

@objc protocol AddMemeRoutingLogic {
    func routeToListMemes(segue: UIStoryboardSegue?)
}

protocol AddMemeDataPassing {
    var dataStore: AddMemeDataStore? { get }
}

class AddMemeRouter: NSObject, AddMemeRoutingLogic, AddMemeDataPassing {
    weak var viewController: AddMemeViewController?
    var dataStore: AddMemeDataStore?

    // MARK: Routing

    func routeToListMemes(segue: UIStoryboardSegue?) {
        var destinationVC: ListMemesViewController

        if let segue = segue {
            destinationVC = segue.destination as! ListMemesViewController
        } else {
            let index = viewController!.navigationController!.viewControllers.count - 2
            destinationVC = viewController?.navigationController?.viewControllers[index] as! ListMemesViewController
        }

        var destinationDS = destinationVC.router!.dataStore!

        passDataToListMemes(source: dataStore!, destination: &destinationDS)
        navigateToListMemes(source: viewController!, destination: destinationVC)
    }

    // MARK: Navigation

    func navigateToListMemes(source: AddMemeViewController, destination: ListMemesViewController) {
        source.navigationController?.popViewController(animated: true)
    }

    // MARK: Passing Data

    func passDataToListMemes(source: AddMemeDataStore, destination: inout ListMemesDataStore) {
        // do nothing, handled by view lifecycle
    }
}
