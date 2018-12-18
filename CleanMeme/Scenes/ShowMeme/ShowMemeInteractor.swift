//
//  ShowMemeInteractor.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol ShowMemeBusinessLogic {
    func getMeme(request: ShowMeme.GetMeme.Request)
}

protocol ShowMemeDataStore {
    var meme: Meme! { get set }
}

class ShowMemeInteractor: ShowMemeBusinessLogic, ShowMemeDataStore {
    var presenter: ShowMemePresentationLogic?

    var meme: Meme!

    // MARK: Fetch meme

    func getMeme(request: ShowMeme.GetMeme.Request) {
        let response = ShowMeme.GetMeme.Response(meme: meme)
        presenter?.presentMeme(response: response)
    }
}
