//
//  FeedViewController.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/24/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

// Image Shack API Key: 12DJKPSU5fc3afbd01b1630cc718cae3043220f3

import UIKit
import FirebaseDatabase

class FeedViewController: UIViewController {
    
    @IBOutlet weak var postEntryText: MaterialTextField!
    @IBOutlet weak var postEntryImage: UIImageView!
    @IBOutlet weak var feedTableView: UITableView!
    
    static var imageCache = NSCache<NSString, UIImage>()
    var posts = [Post]()

    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.estimatedRowHeight = 300
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // FIXME: Loads every post ever made. Limit to most recent posts.
        DataService.instance.REF_POSTS.observe(.value, with: {snapshot in
            if snapshot.value != nil { // FIXME: Potential to destabilize UI with numerous updates from other users.
                self.posts.removeAll()
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        if let postData = snap.value as? Dictionary<String, Any> {
                            let postKey = snap.key
                            if let post = Post(postKey: postKey, data: postData) {
                                self.posts.append(post)
                            }
                        }
                    }
                }
                
                self.feedTableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        feedTableView.reloadData()
    }
    
    @IBAction func selectMedia(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true)
    }

    @IBAction func makePost(_ sender: UIButton) {
        if let postText = postEntryText.text, !postText.isEmpty {
            var imageData: Data? = nil
            
            if let postImage = postEntryImage.image, postImage != #imageLiteral(resourceName: "camera") {
                imageData = UIImageJPEGRepresentation(postImage, 0.2)
            }
            
            DataService.instance.createPost(postDescription: postText, postImage: imageData)
            
            resetPostEntryFields()
        }
    }
    
    func resetPostEntryFields() {
        postEntryText.text = ""
        postEntryImage.image = #imageLiteral(resourceName: "camera")
        feedTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // Potentially dispose of extra posts.
        // TODO: Dump cache
        // May have issue with several large images being scaled down.
        // TODO: Ensure images are scaled properly before being uploaded/downloaded.
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        //FIXME: Row height should be calculated dynamically to fit contents.
        if post.imageUrl == nil {
            return 175
        } else {
            return feedTableView.estimatedRowHeight
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostTableViewCell {
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let url = post.imageUrl {
                image = FeedViewController.imageCache.object(forKey: url as NSString)
            }
            
            cell.configureCell(post, image: image)
            return cell
        }
        
        return PostTableViewCell()
    }
}

extension FeedViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            postEntryImage.image = image
        }
    }
}

extension FeedViewController: UINavigationControllerDelegate {
    
}
