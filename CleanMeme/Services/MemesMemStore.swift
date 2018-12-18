//
//  MemesMemStore.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import Foundation

class MemesMemStore: MemesStoreProtocol, MemesStoreUtilityProtocol {
    func addMeme(memeToAdd: Meme, completionHandler: @escaping MemesStoreAddMemeCompletionHandler) {
        var meme = memeToAdd
        generateMemeId(meme: &meme)
        // an error here would mean something went wrong with persistence
        completionHandler(MemesStoreResult.Success(result: meme))
    }
}
