//
//  FavoriteButton.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/29/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

        setImage(#imageLiteral(resourceName: "favoriteIcon"), for: .normal)
        setImage(#imageLiteral(resourceName: "favoriteIconSelected"), for: .selected)
    }
    
    func toggleSelected() {
        isSelected = !isSelected
    }
    
}
