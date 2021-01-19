//
//  MoviesViewController.swift
//  webflix
//
//  Created by Anthea Nguyen on 1/12/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Table view "recipe":
    // Step 1: Add in UITableViewDataSource & UITableViewDelegate
    // Step 2: Implement the two added fxns
    // Step 3:
    // tableView.dataSource = self
    // tableView.delegate = self
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // Creates an array of dictionaries
    var movies = [[String:Any]]() // This is a dictionary

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        print("hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try!
                JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            // This code above downloads movie and stores it in self.movies
            
            self.movies = dataDictionary["results"] as! [[String:Any]] // accessing a key inside a dictionary
            
            
            self.tableView.reloadData()
        
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // For this particular row, give me the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        // go back to api and look at the options
        let title = movie["title"] as! String // casting tells you the type "as!" is casting
        
        // cell.textLabel!.text = title
        // "row: \(indexPath.row)"  backslash replaces the entire section with the val of that variable
        cell.titleLabel.text = title
        
        // the synopsis is called overview
        let synopsis = movie["overview"] as! String
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        cell.posterView.af_setImage(withURL: posterUrl)
        
        return cell
    
    }
    

    
     // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
        
        // This prints whenever we click on the details screen
        print("Loading up the details screen")
        
        // Finding the selected movie
        let cell = sender as! UITableViewCell // Hey this is the cell we tapped on
        let indexPath = tableView.indexPath(for: cell)! // Asks tableView what the index path is
        let movie = movies[indexPath.row] // Access the array
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController // Casting in order to access that property
        
        detailsViewController.movie = movie // referring to the movie we found above
        
        tableView.deselectRow(at: indexPath, animated: true) // Unhighlights the selected area
    }
    

}

// About pods:
// Pods are libraries that other people made
// to create a pod for your swift file go to terminal > directory of your swift file > "pod init"
// After creating this if you do "ls" you'll see that a Podfile was created in your project's folder directory
// To OPEN this podfile simply type "open Podfile"

// While in the Podfile
// Type in the pod you want
