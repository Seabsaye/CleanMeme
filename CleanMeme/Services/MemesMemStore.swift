//
//  MemesMemStore.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import Foundation

class MemesMemStore: MemesStoreProtocol, MemesStoreUtilityProtocol {

    // MARK: Data

    static var memes: [Meme] = []

    // MARK: CRUD Operations

    func addMeme(memeToAdd: Meme, completionHandler: @escaping MemesStoreAddMemeCompletionHandler) {
        var meme = memeToAdd
        generateMemeId(meme: &meme)
        type(of: self).memes.append(meme)
        // an error here would mean something went wrong with persistence
        completionHandler(MemesStoreResult.Success(result: meme))
    }

    func fetchMemes(completionHandler: @escaping MemesStoreFetchMemesCompletionHandler) {
        // an error here would mean something went wrong with persistence
        completionHandler(MemesStoreResult.Success(result: type(of: self).memes))
    }
}

typealias MemesStoreAddMemeCompletionHandler = (MemesStoreResult<Meme>) -> ()
typealias MemesStoreFetchMemesCompletionHandler = (MemesStoreResult<[Meme]>) -> ()

enum MemesStoreResult<U> {
    case Success(result: U)
    case Failure(error: MemesStoreError)
}

enum MemesStoreError: Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}
