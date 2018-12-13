//
//  AddMemeModels.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

enum AddMeme {
    struct MemeFormFields {
        var memeName: String
        var memeUrl: String
        var memeImage: UIImage
    }

    struct Request {
        var memeFormFields: MemeFormFields
    }
}
