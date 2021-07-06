//
//  MovieTableViewCell.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 06/07/2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var moviePosterImage: UIImageView!
    @IBOutlet private weak var movieTitleLbl: UILabel!
    @IBOutlet private weak var movieReleaseYearLbl: UILabel!
    
    public func configure(with viewModel: MoviesViewModel, _ indexPath: IndexPath) {
        
        guard !viewModel.isLoading else {
            contentView.smartShimmer()
            return
        }
        
        contentView.stopSmartShimmer()
        moviePosterImage.loadImage(withUrl: viewModel.moviePosterUrl(forIndex: indexPath.row), showLoader: true)
        movieTitleLbl.text = viewModel.movieTitle(forIndex: indexPath.row)
        movieReleaseYearLbl.text = viewModel.movieReleaseYear(forIndex: indexPath.row)
    }
}
