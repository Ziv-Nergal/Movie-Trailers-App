//
//  MovieDetailsViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 07/07/2021.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet private weak var moviePosterImage: UIImageView!
    @IBOutlet private weak var movieTitleLbl: UILabel!
    @IBOutlet private weak var movieReleaseYearLbl: UILabel!
    @IBOutlet private weak var movieOverviewLbl: UILabel!
    @IBOutlet private weak var likeMovieBtn: UIButton!
    @IBOutlet private weak var movieRatingLbl: UILabel!
    
    var viewModel: MovieDetailsViewModel!
    weak var coordinator: MainCoordinator?
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Initiation
    
    private func setupViews() {
        moviePosterImage.loadImage(withUrl: viewModel.moviePosterUrl)
        movieTitleLbl.text = viewModel.movieTitle
        movieReleaseYearLbl.text = viewModel.movieReleaseYear
        movieOverviewLbl.text = viewModel.movieOverview
        movieRatingLbl.text = viewModel.movieRating
        likeMovieBtn.isSelected = viewModel.isFavoriteMovie
    }
    
    // MARK: - Click Events
    
    @IBAction func likeMovieBtnClick(_ sender: UIButton) {
        //TODO - Implement
    }
}
