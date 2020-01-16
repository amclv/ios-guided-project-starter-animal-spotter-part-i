//
//  AnimalDetailViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalDetailViewController: UIViewController {
    
    var apiController: APIController?
    var animalName: String?
    
    // MARK: - Properties
    
    @IBOutlet weak var timeSeenLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
    }
    
    func getDetails() {
        guard let apiController = apiController,
            let animalName = animalName else { return }
        
        apiController.fetchDetails(for: animalName) { (result) in
            if let animal = try? result.get() {
                DispatchQueue.main.async {
                    self.updateViews(with: animal)
                }
                apiController.fetchImage(at: animal.imageURL) { (result) in
                    if let image = try? result.get() {
                        DispatchQueue.main.async {
                            self.animalImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    func updateViews(with animal: Animal) {
        title = animal.name
        descriptionLabel.text = animal.description
        coordinatesLabel.text = "Lat: \(animal.latitude), Long: \(animal.longitude)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        timeSeenLabel.text = formatter.string(from: animal.timeSeen)
    }
    
}
