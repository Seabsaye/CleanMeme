//
//  AddMemeInteractor.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol AddMemeBusinessLogic {
    func addMeme(request: AddMeme.Request)
}

protocol AddMemeDataStore {

}

class AddMemeInteractor: AddMemeBusinessLogic, AddMemeDataStore {
    var presenter: AddMemePresentationLogic?


    // MARK: Create order

    func addMeme(request: AddMeme.Request) {

    }
}
