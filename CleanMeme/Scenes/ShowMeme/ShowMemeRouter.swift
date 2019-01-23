//
//  ShowMemeRouter.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 2019-01-22.
//  Copyright © 2019 Sebastian Kolosa. All rights reserved.
//

import UIKit

@objc protocol ShowMemeRoutingLogic { }

protocol ShowMemeDataPassing {
  var dataStore: ShowMemeDataStore? { get }
}

class ShowMemeRouter: NSObject, ShowMemeRoutingLogic, ShowMemeDataPassing {
  weak var viewController: ShowMemeViewController?
  var dataStore: ShowMemeDataStore?
}
