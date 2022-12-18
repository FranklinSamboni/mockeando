//
//  SceneDelegate.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: CoreDataStore = {
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")
        return try! CoreDataStore(storeURL: storeURL)
    }()
    
    private lazy var rootViewController: UINavigationController = {
        let nav = UINavigationController()
        nav.viewControllers = [composePostsFeature()]
        return nav
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    private func composePostsFeature() -> UIViewController {
        let endpointURL = PostsEndpoint.get.url(baseURL: baseURL)
        let remoteLoader = RemoteLoader(httpClient: httpClient, url: endpointURL)
        let adapter = PostsPresenterAdapter(remoteLoader: remoteLoader, localLoader: store, postCache: store)
        
        let storyboard = UIStoryboard(name: "Posts", bundle: .main)
        let postsViewController = storyboard.instantiateInitialViewController() as! PostsViewController
        
        let presenter = PostsPresenter(postsView: postsViewController,
                                       loadingView: postsViewController,
                                       errorView: postsViewController,
                                       adapter: adapter)
        
        postsViewController.onLoad = presenter.load
        postsViewController.onFavorite = presenter.onFavorite
        postsViewController.onUnfavorite = presenter.onUnfavorite
        postsViewController.onDeleteItems = presenter.onDelete
        postsViewController.onClick = { [weak self] postId, userId in
            self?.showDetail(postId: postId, userId: userId)
        }
        
        return postsViewController
    }
    
    private func showDetail(postId: Int, userId: Int) {
        let viewController = composePostDetailFeature(postId: postId, userId: userId)
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    private func composePostDetailFeature(postId: Int, userId: Int) -> UIViewController {
        let postURL = PostsEndpoint.getBy(id: String(postId)).url(baseURL: baseURL)
        let postRemoteLoader = RemoteLoader(httpClient: httpClient, url: postURL)
        
        let commentsURL = PostCommentsEndpoint.get(id: String(postId)).url(baseURL: baseURL)
        let commentsRemoteLoader = RemoteLoader(httpClient: httpClient, url: commentsURL)
        
        let userURL = UserEndpoint.get(id: String(userId)).url(baseURL: baseURL)
        let userRemoteLoader = RemoteLoader(httpClient: httpClient, url: userURL)
        
        let adapter = PostDetailsPresenderAdater(postLoader: postRemoteLoader,
                                                 commentsLoader: commentsRemoteLoader,
                                                 userLoader: userRemoteLoader)
        
        let storyboard = UIStoryboard(name: "PostDetail", bundle: .main)
        let detailViewController = storyboard.instantiateInitialViewController() as! PostDetailViewController

        let presenter = PostDetailPresenter(detailView: detailViewController,
                                            loadingView: detailViewController,
                                            errorView: detailViewController,
                                            adapter: adapter)
        
        detailViewController.onLoad = presenter.load
        
        return detailViewController
    }
}

