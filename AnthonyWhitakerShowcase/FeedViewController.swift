//
//  FeedViewController.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/24/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        DataService.instance.REF_POSTS.observe(.value, with: {snapshot in
            if snapshot.value != nil { // FIXME: Potential to destabilize UI with numerous updates from other users.
                print(snapshot.value!)
                self.feedTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedViewController: UITableViewDelegate {
    
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
    }
}
