//
//  DetailViewController.swift
//  mready
//
//  Created by Arnold Mitricã on 11.05.2021.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    @IBOutlet var fullName: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var language: UILabel!
    @IBOutlet var forkCount: UILabel!
    @IBOutlet var stargazersCount: UILabel!
    @IBOutlet var updatedAt: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var containerView: UIView!
    var avatarImageURL:String!{
        didSet{
            guard let url = avatarImageURL else { return }
            avatarImageView.sd_setImage(with: URL(string: url), completed: nil)
        }
    }
    
    var viewModel:RepositoryDetailViewModel!{
        didSet{
            if isViewLoaded{
                configure(with: viewModel)
                containerView.backgroundColor = .red
                //containerView.layer.backgroundColor = .init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = viewModel{
            configure(with: viewModel)
            containerView.backgroundColor = #colorLiteral(red: 0.6852164865, green: 0.1684162915, blue: 0.1606773734, alpha: 0.375625367)
            containerView.layer.cornerRadius = 18
            avatarImageView.layer.cornerRadius = 18
            avatarImageView.layer.borderWidth = 3
            avatarImageView.layer.borderColor = #colorLiteral(red: 0.6380566955, green: 0.3249495029, blue: 0.6226760149, alpha: 0.5)
            title = viewModel.fullName
            //containerView.layer.backgroundColor = .init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        }
        
        // Do any additional setup after loading the view.
    }

    func configure(with viewModel: RepositoryDetailViewModel){
        fullName.text = "Repository:" + viewModel.fullName
        itemDescription.text = viewModel.itemDescription
        language.text = "Language:" + (viewModel.language ?? "Several languages")
        if let fork = viewModel.forkCount{
            forkCount.text = "Forks:" + String(fork)
        }
        //forkCount.text = String(format: "%@", viewModel.forkCount ?? "0")
        if let stars = viewModel.stargazersCount{
            stargazersCount.text = "Stars:" + String(stars)
        }
        //stargazersCount.text = String(format: "%@", viewModel.stargazersCount ?? "0")
        updatedAt.text = "updatedAt:" + (viewModel.updatedAt ?? "Not updated")
        avatarImageURL = viewModel.avatarOwnerURL
        ownerName.text = viewModel.ownerName
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
