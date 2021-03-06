//
//  MemesWorker.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import Foundation

protocol MemesStoreProtocol {
    func addMeme(memeToAdd: Meme, completionHandler: @escaping MemesStoreAddMemeCompletionHandler)
    func fetchMemes(completionHandler: @escaping MemesStoreFetchMemesCompletionHandler)
}

protocol MemesStoreUtilityProtocol {}

extension MemesStoreUtilityProtocol {
    func generateMemeId(meme: inout Meme) {
        guard meme.id == nil else { return }
        meme.id = "\(arc4random())"
    }
}

class MemesWorker {
    var memesStore: MemesStoreProtocol

    init(memesStore: MemesStoreProtocol) {
        self.memesStore = memesStore
    }

    func addMeme(memeToAdd: Meme, completionHandler: @escaping MemesWorkerAddMemeCompletionHandler) {
        memesStore.addMeme(memeToAdd: memeToAdd) { result in
            switch result {
            case .Success(result: let meme):
                DispatchQueue.main.async { completionHandler(meme) }
            case .Failure(error: let error):
                // outputting a technical log is scoped by the Worker
                // displaying a corresponding readable message to a user is owned by the View Controller
                print(error)
                DispatchQueue.main.async { completionHandler(nil) }
            }
        }
    }

    func fetchMemes(completionHandler: @escaping MemesWorkerFetchMemeCompletionHandler) {
        memesStore.fetchMemes { result in
            switch result {
            case .Success(result: let memes):
                DispatchQueue.main.async { completionHandler(memes) }
            case .Failure(error: let error):
                // outputting a technical log is scoped by the Worker
                // displaying a corresponding readable message to a user is owned by the View Controller
                print(error)
                DispatchQueue.main.async { completionHandler([]) }
            }
        }
    }
}

typealias MemesWorkerAddMemeCompletionHandler = (Meme?) -> ()
typealias MemesWorkerFetchMemeCompletionHandler = ([Meme]) -> ()
