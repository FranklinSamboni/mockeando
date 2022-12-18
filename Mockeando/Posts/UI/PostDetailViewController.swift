//
//  PostDetailViewController.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var onLoad: (() -> Void)!
    
    var viewModel: PostDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = uiRefreshControl
    }
    
    @objc private func refresh() {
        onLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return "Comments"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel?.comments.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as! PostDetailTableViewCell
            cell.titleLabel.text = viewModel?.title
            cell.bodyLabel.text = viewModel?.body
            cell.authorInfoLabel.text = viewModel?.authorInfo
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            let comment = viewModel?.comments[indexPath.row]
            cell.titleLabel.text = comment?.title
            cell.bodyLabel.text = comment?.description
            cell.emailLabel.text = comment?.author
            return cell
        }
    }
}

extension PostDetailViewController: PostDetailView {
    func display(_ viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

extension PostDetailViewController: ErrorView {
    func display(_ viewModel: ErrorViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.buttonTitle, style: .default))
        
        present(alert, animated: true)
    }
}

extension PostDetailViewController: LoadingView {
    func display(_ viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            tableView.refreshControl?.beginRefreshing()
        } else {
            tableView.refreshControl?.endRefreshing()
        }
    }
}
