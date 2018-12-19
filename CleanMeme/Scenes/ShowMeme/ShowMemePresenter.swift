//
//  ShowMemePresenter.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol ShowMemePresentationLogic {
    func presentMeme(response: ShowMeme.GetMeme.Response)
}

class ShowMemePresenter: ShowMemePresentationLogic {
    weak var viewController: ShowMemeDisplayLogic?

    // Mark: Fetch meme

    func presentMeme(response: ShowMeme.GetMeme.Response) {
        let meme = response.meme
        // format data to simple information that is easy to display
        let viewModel = ShowMeme.GetMeme.ViewModel(displayedMeme: ShowMeme.GetMeme.ViewModel.DisplayedMeme(id: meme.id!, name: meme.name, url: meme.url, image: meme.image)
        )
        viewController?.displayMeme(viewModel: viewModel)
    }
}
