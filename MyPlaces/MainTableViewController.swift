//
//  MainTableViewController.swift
//  MyPlaces
//
//  Created by Vladimir Strepitov on 03.05.2022.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var restPlaces = [
        "KFC",
        "Phali Hinkali",
        "Bros Buritos",
        "Ketchup Burgers",
        "Tokio City",
        "Burger King",
        "Teremok",
        "Cofix",
        "Hitch",
        "DoDo Pizza"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restPlaces.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = restPlaces[indexPath.row]
        cell.imageOfPlace.image = UIImage(named: restPlaces[indexPath.row])
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true
        return cell
    }
    
    // MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
