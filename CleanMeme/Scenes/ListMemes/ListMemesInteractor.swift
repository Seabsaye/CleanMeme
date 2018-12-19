//
//  ListMemesInteractor.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol ListMemesBusinessLogic {
    func fetchMemes(request: ListMemes.FetchMemes.Request)
}

protocol ListMemesDataStore {
    var memes: [Meme]? { get }
}

class ListMemesInteractor: ListMemesBusinessLogic, ListMemesDataStore {
    var presenter: ListMemesPresentationLogic?
    var memesWorker = MemesWorker(memesStore: MemesMemStore())

    var memes: [Meme]?

    // MARK: Fetch memes

    func fetchMemes(request: ListMemes.FetchMemes.Request) {
        memesWorker.fetchMemes { [weak self] memes in
            guard let weakSelf = self else { return }
            weakSelf.memes = memes
            let response = ListMemes.FetchMemes.Response(memes: memes)
            weakSelf.presenter?.presentFetchedMemes(response: response)
        }
    }
}

