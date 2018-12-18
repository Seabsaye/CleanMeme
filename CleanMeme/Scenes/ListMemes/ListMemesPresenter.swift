//
//  ListMemesPresenter.swift
//  CleanMeme
//
//  Created by Sebastian Kolosa on 12/17/18.
//  Copyright © 2018 Sebastian Kolosa. All rights reserved.
//

import UIKit

protocol ListMemesPresentationLogic {
    func presentFetchedMemes(response: ListMemes.FetchMemes.Response)
}

class ListMemesPresenter: ListMemesPresentationLogic {
    weak var viewController: ListMemesDisplayLogic?

    // MARK: Fetch memes
    func presentFetchedMemes(response: ListMemes.FetchMemes.Response) {
        var displayedMemes: [ListMemes.FetchMemes.ViewModel.DisplayedMeme] = []
        // format data to simple information that is easy to display
        response.memes.forEach { displayedMemes.append(ListMemes.FetchMemes.ViewModel.DisplayedMeme(id: $0.id!, name: $0.name, url: $0.url, image: $0.image)) }
        let viewModel = ListMemes.FetchMemes.ViewModel(displayedMemes: displayedMemes)
        viewController?.displayFetchedMemes(viewModel: viewModel)
    }
}
