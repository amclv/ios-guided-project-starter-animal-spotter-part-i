//
//  AnimalsTableViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var animalNames: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let apiController = APIController()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // transition to login view if conditions require
        if apiController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = animalNames[indexPath.row]

        return cell
    }

    // MARK: - Actions
    
    @IBAction func getAnimals(_ sender: UIBarButtonItem) {
        // fetch all animals from API
        
        // if you don't care about the errors returned by the Result type:
        apiController.fetchAllAnimalNames { (result) in
            if let names = try? result.get() {
                DispatchQueue.main.async {
                    self.animalNames = names
                }
            }
        }
    }
        // if you want to enumerate and show each kind of possible error:
    //        apiController.fetchAllAnimalNames { (result) in
    //            do {
    //                let names = try result.get()
    //                DispatchQueue.main.async {
    //                    self.animalNames = names
    //                }
    //            } catch {
    //                if let error = error as? NetworkError {
    //                    switch error {
    //                    case .noAuth:
    //                        print("No Bearer Token Exist")
    //                    case .badAuth:
    //                        print("Bearer Token Invalid")
    //                    case .otherError:
    //                        print("Other error occured, see log")
    //                    case .badData:
    //                        print("No data received, or data corrupted")
    //                    case .noDecode:
    //                        print("JSON could not be decoded")
    //                }
    //            }
    //        }
    //    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.apiController = apiController
            }
        } else if segue.identifier == "ShowAnimalDetailSegue" {
            if let detailVC = segue.destination as? AnimalDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.animalName = animalNames[indexPath.row]
                }
                detailVC.apiController = apiController
            }
        }
    }
}
