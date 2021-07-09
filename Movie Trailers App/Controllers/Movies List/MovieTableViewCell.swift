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
        configure(with: viewModel.movie(forIndex: indexPath.row))
    }
    
    public func configure(with movie: Movie) {
        moviePosterImage.loadImage(withUrl: "\(MovieClient.moviePostersBasePath)\(movie.posterPath ?? "")", showLoader: true)
        movieTitleLbl.text = movie.title 
        movieReleaseYearLbl.text = movie.releaseDate?.formatDate(originFormat: .yyyyMMdd, destinationFormat: .yyyy) ?? "Release date unknown"
    }
}
