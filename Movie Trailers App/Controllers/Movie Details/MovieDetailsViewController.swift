//
//  MovieDetailsViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 07/07/2021.
//

import UIKit
import Hero
import YouTubePlayer

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet private weak var moviePosterImage: UIImageView!
    @IBOutlet private weak var movieTitleLbl: UILabel!
    @IBOutlet private weak var movieReleaseYearLbl: UILabel!
    @IBOutlet private weak var movieOverviewLbl: UILabel!
    @IBOutlet private weak var movieRatingLbl: UILabel!
    @IBOutlet private weak var videoPlayer: YouTubePlayerView!
    
    private var playTrailerButton: UIBarButtonItem!
    private var favoriteButton: UIBarButtonItem!
    
    var viewModel: MovieDetailsViewModel!
    weak var coordinator: MainCoordinator?
    
    // MARK: - Overrides
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
    }
    
    // MARK: - Initiation
    
    private func setupViews() {
        moviePosterImage.loadImage(withUrl: viewModel.moviePosterUrl, errorPlaceholder: .posterImagePlaceholder)
        moviePosterImage.heroID = viewModel.moviePosterUrl
        movieTitleLbl.text = viewModel.movieTitle
        movieReleaseYearLbl.text = viewModel.movieReleaseYear
        movieOverviewLbl.text = viewModel.movieOverview
        movieRatingLbl.text = viewModel.movieRating
        setupNavigationItems()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setupNavigationItems() {
        
        favoriteButton = UIBarButtonItem(
            image: viewModel.isFavoriteMovie ? .systemStarFilled : .systemStar,
            style: .plain,
            target: self,
            action: #selector(likeMovieBtnClick)
        )
        
        playTrailerButton = UIBarButtonItem(
            image: .playFilled,
            style: .plain,
            target: self,
            action: #selector(playTrailerBtnClick)
        )
        
        navigationItem.rightBarButtonItems = [favoriteButton, playTrailerButton]
    }
    
    private func setupDelegates() {
        viewModel.delegate = self
        videoPlayer.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func startVideoPlayer() {
        moviePosterImage.animateAlpha(toVisible: false)
        videoPlayer.animateAlpha(toVisible: true)
        playTrailerButton.image = .stopFilled
        videoPlayer.play()
    }
    
    private func stopVideoPlayer() {
        videoPlayer.stop()
        videoPlayer.animateAlpha(toVisible: false)
        moviePosterImage.animateAlpha(toVisible: true)
        playTrailerButton.image = .playFilled
    }
    
    private func showLoaderOnPlayButton() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemBlue
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = [favoriteButton, barButton]
        activityIndicator.startAnimating()
    }
    
    // MARK: - Click Events
    
    @objc func playTrailerBtnClick(_ sender: UIBarButtonItem) {
        
        if playTrailerButton.image == .stopFilled {
            stopVideoPlayer()
        } else if videoPlayer.ready {
            startVideoPlayer()
        } else {
            viewModel.fetchMovieTrailer()
            showLoaderOnPlayButton()
        }
    }
    
    @objc func likeMovieBtnClick(_ sender: UIBarButtonItem) {
        viewModel.isFavoriteMovie = sender.image == .systemStar
        sender.image = viewModel.isFavoriteMovie ? .systemStarFilled : .systemStar
    }
}

// MARK: - Trailer Video Request Handling

extension MovieDetailsViewController: MovieDetailsViewModelDelegate {
    
    func onMovieTrailerFetchedSuccess(key: String) {
        playTrailerButton.image = .stopFilled
        navigationItem.rightBarButtonItems = [favoriteButton, playTrailerButton]
        moviePosterImage.animateAlpha(toVisible: false)
        videoPlayer.loadVideoID(key)
    }
    
    func onMovieVideosFetchFailed() {
        videoPlayer.isHidden = true
        navigationItem.rightBarButtonItems = [favoriteButton]
        showToast(message: "No trailer was found")
    }
}

extension MovieDetailsViewController: YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
}
