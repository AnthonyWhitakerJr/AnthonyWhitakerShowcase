//
//  PostTableViewCell.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/24/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import UIKit
import Alamofire

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeButton: FavoriteButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(_ post: Post, imageCache: NSCache<NSString, UIImage>) {
        self.post = post
        postImage.isHidden = true
        
        userNameLabel.text = post.username
        likeCountLabel.text = "\(post.likes)"
        postText.text = post.postDescription
        
        if let url = post.imageUrl {
            if let image = imageCache.object(forKey: url as NSString) {
                postImage.image = image
                postImage.isHidden = false
            } else {
                request = Alamofire.request(url).validate(contentType: ["image/*"]).responseData(completionHandler: { responseData in
                    if let data = responseData.data {
                        if let image = UIImage(data: data) {
                            self.postImage.isHidden = false
                            self.postImage.image = image
                            imageCache.setObject(image, forKey: url as NSString)
                        }
                    }
                })
            }
        }
        
        // FIXME: Asynchronous. Potentially corrupted by fast scrolling. Mirror request handling seen above.
        DataService.instance.isLikedByCurrentUser(post: post, completion: { result in
            self.likeButton.isSelected = result
        })
        
    }
    
    @IBAction func likeButtonPressed(_ sender: FavoriteButton) {
        sender.toggleSelected()
        DataService.instance.updateLikes(for: post, wasLiked: sender.isSelected)
    }
    
    
    override func draw(_ rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
//        postImage.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
