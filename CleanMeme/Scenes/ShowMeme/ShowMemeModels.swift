//
//  ShowMemeModels.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

enum ShowMeme {
    // MARK: Use cases
    enum GetMeme {
        struct Request {}
        struct Response {
            var meme: Meme
        }
        struct ViewModel {
            struct DisplayedMeme {
                var id: String
                var name: String
                var url: String
                var image: UIImage
            }
            var displayedMeme: DisplayedMeme
        }
    }
}
