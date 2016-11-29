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
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(_ post: Post, image: UIImage?) {
        self.post = post
        
        userNameLabel.text = post.username
        likeCountLabel.text = "\(post.likes)"
        postText.text = post.postDescription
        
        if let url = post.imageUrl {
            if let image = image {
                postImage.image = image
            }
            
            request = Alamofire.request(url).validate(contentType: ["image/*"]).responseData(completionHandler: { responseData in
                if let data = responseData.data {
                    if let image = UIImage(data: data) {
                        self.postImage.image = image
                        FeedViewController.imageCache.setObject(image, forKey: url as NSString)
                    }
                }
            })
            
        } else {
            postImage.isHidden = true
        }
        
        
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
