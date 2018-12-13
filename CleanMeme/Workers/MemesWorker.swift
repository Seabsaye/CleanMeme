//
//  MemesWorker.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import Foundation

protocol MemesStoreProtocol {

}

class MemesWorker {
    var memesStore: MemesStoreProtocol

    init(memesStore: MemesStoreProtocol) {
        self.memesStore = memesStore
    }
}
