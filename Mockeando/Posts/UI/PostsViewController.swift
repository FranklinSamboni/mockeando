//
//  PostViewController.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import UIKit

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let cellIdentifier = "BasicTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var selectAllBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButtonView: UIView!
    
    var viewModel = PostsViewModel(favorites: [], lists: [])
    
    var onLoad: (() -> Void)!
    
    var onFavorite: ((PostViewModel) -> Void)?
    var onUnfavorite: ((PostViewModel) -> Void)?
    var onDeleteItems: (([PostViewModel]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = PostsPresenter.title
        onLoad()
        
        let uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = uiRefreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        
        editBarButton.title = PostsPresenter.edit
        selectAllBarButton.title = PostsPresenter.selectAll
        selectAllBarButton.isHidden = true
        deleteButtonView.isHidden = true
    }
    
    @objc private func refresh() {
        onLoad()
    }

    @IBAction func onEdit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        editBarButton.title = tableView.isEditing ? PostsPresenter.cancel : PostsPresenter.edit
        selectAllBarButton.isHidden = !tableView.isEditing
        deleteButtonView.isHidden = !tableView.isEditing
        
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        tableView.reloadRows(at: visibleIndexPaths, with: .automatic)
    }
    
    @IBAction func onSelectAll(_ sender: Any) {
        for section in 0..<numberOfSections(in: tableView) {
            for row in 0..<tableView(tableView, numberOfRowsInSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if canEditRow(at: indexPath) {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            }
        }
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let indexPaths = tableView.indexPathsForSelectedRows
        
        let items = indexPaths?.compactMap { indexPath in
            if canEditRow(at: indexPath) {
                return itemForSection(indexPath: indexPath)
            }
            return nil
        }
        
        guard let items = items else { return }
        onDeleteItems?(items)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return PostsPresenter.favorites
        } else {
            return PostsPresenter.lists
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return viewModel.favorites.count > 0 ? 50 : 0
        } else {
            return viewModel.lists.count > 0 ? 50 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.favorites.count
        } else {
            return viewModel.lists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BasicTableViewCell
        
        let item = itemForSection(indexPath: indexPath)
        cell.titleLabel.text = item.title
        
        cell.selectionStyle = tableView.isEditing && canEditRow(at: indexPath) ? .default : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canEditRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = itemForSection(indexPath: indexPath)
        
        let favoriteAction = UIContextualAction(style: .normal, title: PostsPresenter.favorite) { [weak self] action, view, completionHandler in
            self?.onFavorite?(item)
            completionHandler(true)
        }
        favoriteAction.backgroundColor = UIColor(red: 0, green: 171/255, blue: 65/255, alpha: 1.0)
        
        let unfavoriteAction = UIContextualAction(style: .normal, title: PostsPresenter.unfavorite) { [weak self] action, view, completionHandler in
            self?.onUnfavorite?(item)
            completionHandler(true)
        }
        unfavoriteAction.backgroundColor = .red
        
        let actions = item.isFavorite ? [unfavoriteAction] : [favoriteAction]
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    private func itemForSection(indexPath: IndexPath) -> PostViewModel {
        let item = indexPath.section == 0 ? viewModel.favorites[indexPath.row] : viewModel.lists[indexPath.row]
        return item
    }
    
    private func canEditRow(at indexPath: IndexPath) -> Bool {
        let item = itemForSection(indexPath: indexPath)
        
        let canEdit = !tableView.isEditing || (tableView.isEditing && !item.isFavorite)
        return canEdit
    }
}

extension PostsViewController: PostsView {
    func display(_ viewModel: PostsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

extension PostsViewController: ErrorView {
    func display(_ viewModel: ErrorViewModel) {
        let alert = UIAlertController(title: PostsPresenter.errorTitle, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: PostsPresenter.ok, style: .default))
        
        present(alert, animated: true)
    }
}

extension PostsViewController: LoadingView {
    func display(_ viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            tableView.refreshControl?.beginRefreshing()
        } else {
            tableView.refreshControl?.endRefreshing()
        }
    }
}
