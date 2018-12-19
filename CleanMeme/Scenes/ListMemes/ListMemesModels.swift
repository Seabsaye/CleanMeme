//
//  ListMemesModels.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

enum ListMemes {
    // Mark: Use cases
    enum FetchMemes {
        struct Request {}
        struct Response {
            var memes: [Meme]
        }
        struct ViewModel {
            struct DisplayedMeme {
                var id: String
                var name: String
                var url: String
                var image: UIImage
            }
            var displayedMemes: [DisplayedMeme]
        }
    }
}
