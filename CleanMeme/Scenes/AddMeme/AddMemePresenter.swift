//
//  AddMemePresenter.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/12/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol AddMemePresentationLogic {
    func presentAddedMeme(response: AddMeme.Response)
}

class AddMemePresenter: AddMemePresentationLogic {
    weak var viewController: AddMemeDisplayLogic?

    func presentAddedMeme(response: AddMeme.Response) {
        // format data to simple information that is easy to display
        let viewModel = AddMeme.ViewModel(meme: response.meme)
        viewController?.displayAddedMeme(viewModel: viewModel)
    }
}
