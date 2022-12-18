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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let rootViewController = UINavigationController()
        
        rootViewController.viewControllers = [composePostsFeature()]
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
        
        return postsViewController
    }
}

