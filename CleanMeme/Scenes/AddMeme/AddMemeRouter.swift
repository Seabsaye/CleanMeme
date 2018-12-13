//
//  AddMemeRouter.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

@objc protocol AddMemeRoutingLogic {

}

protocol AddMemeDataPassing {
    var dataStore: AddMemeDataStore? { get }
}

class AddMemeRouter: NSObject, AddMemeRoutingLogic, AddMemeDataPassing {
    weak var viewController: AddMemeViewController?
    var dataStore: AddMemeDataStore?
}
