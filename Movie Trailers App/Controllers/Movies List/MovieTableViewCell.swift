//
//  MovieTableViewCell.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 06/07/2021.
//

import UIKit
import Hero

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
        let posterUrl = "\(MovieClient.moviePostersBasePath)\(movie.posterPath ?? "")"
        moviePosterImage.loadImage(withUrl: posterUrl, showLoader: true, errorPlaceholder: .posterImagePlaceholder)
        moviePosterImage.heroID = posterUrl
        movieTitleLbl.text = movie.title
        movieReleaseYearLbl.text = movie.releaseDate?.formatDate(originFormat: .yyyyMMdd, destinationFormat: .yyyy) ?? "Release date unknown"
    }
}
