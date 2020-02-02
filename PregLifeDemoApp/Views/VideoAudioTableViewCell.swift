//
//  VideoAudioTableViewCell.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import UIKit

class VideoAudioTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favIcon: UIButton!
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView!.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    var viewModel: ItemTableViewCellVM? {
        didSet{
            
          
            let url = URL(string: viewModel!.imageUrl)!
               downloadImage(from: url)
            
            if(viewModel?.isNew == true) {
                // Define attributes
                let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
                let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
                // Create attributed string
                let attrString = NSAttributedString(string: viewModel!.title, attributes:attributes as [NSAttributedString.Key : Any])
                titleLabel.attributedText = attrString
                print(viewModel!.title)
               
            } else {
                // Define attributes
                let labelFont = UIFont(name: "HelveticaNeue", size: 18)
                let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
                // Create attributed string
                let attrString = NSAttributedString(string: viewModel!.title, attributes:attributes as [NSAttributedString.Key : Any])
                titleLabel.attributedText = attrString
            }
            
            if(viewModel?.isFav == true) {
                favIcon.setImage(#imageLiteral(resourceName: "iconfinder_star_383219"), for: .normal)
                
            }else {
                
                favIcon.setImage(#imageLiteral(resourceName: "iconfinder_star-empty_383218"), for: .normal)
            }
            
            
        }
    }
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        if(viewModel?.isFav == true) {
            viewModel?.isFav = false
        } else {
            viewModel?.isFav = true
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//        //   self.viewModel?.isNew = false
//    }
    
}
extension VideoAudioTableViewCell: VMCellProtocol {
    
    func didSelected() {
        self.viewModel?.isNew = false
    }
    
    func fill(by vm: ItemTableViewCellVM) {
        viewModel = vm
    }
    
}
