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
    var memeToEdit: Meme? { get set }
}

class AddMemeInteractor: AddMemeBusinessLogic, AddMemeDataStore {
    var presenter: AddMemePresentationLogic?
    var memesWorker = MemesWorker(memesStore: MemesMemStore())
    var memeToEdit: Meme?

    // MARK: Create order

    func addMeme(request: AddMeme.Request) {
        let memeFormFields = request.memeFormFields
        // convert data models
        let memeToAdd = Meme(id: nil, name: memeFormFields.memeName, url: memeFormFields.memeUrl, image: memeFormFields.memeImage)
        memesWorker.addMeme(memeToAdd: memeToAdd) { meme in
            self.memeToEdit = meme
            let response = AddMeme.Response(meme: meme)
            self.presenter?.presentAddedMeme(response: response)
        }
    }
}
