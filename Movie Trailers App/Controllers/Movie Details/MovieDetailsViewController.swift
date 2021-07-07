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
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Initiation
    
    private func setupViews() {
        //TODO: implement
    }
    
    // MARK: - Private Methods
    
    // MARK: - Click Events
}
