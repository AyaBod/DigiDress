//
//  OverallAnalysisViewController.swift
//  DigiDress2.2
//
//  Created by AYANNA BODAKE on 7/14/24.
//
import UIKit

class OverallAnalysisViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var albums: [Album] {
        return AlbumManager.shared.albums
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TotalCell") // Register TotalCell here

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count + 1 //one more for the total
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath)
                let totalCount = albums.reduce(0) { $0 + $1.photos.count }
                let donatedCount = albums.first(where: { $0.name.lowercased() == "donated" })?.photos.count ?? 0
                let finalCount = totalCount - donatedCount
                cell.textLabel?.text = "Total Garments (excluding donated): \(finalCount)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
                let album = albums[indexPath.row - 1]
                cell.textLabel?.text = "\(album.name): \(album.photos.count)"
                return cell
            }
        }


        @IBAction func closeButtonTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
    }
