//
//  SceneDelegate.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))

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
        let postsLoader = RemoteLoader(httpClient: httpClient, url: endpointURL)
        let mainQueueLoader = PostsLoaderMainQueueDecorator(decorator: postsLoader)
        
        let storyboard = UIStoryboard(name: "Posts", bundle: .main)
        let postsViewController = storyboard.instantiateInitialViewController() as! PostsViewController
        
        let presenter = PostsPresenter(postsView: postsViewController,
                                       loadingView: postsViewController,
                                       errorView: postsViewController,
                                       loader: mainQueueLoader)
        
        postsViewController.onLoad = presenter.load
        postsViewController.onFavorite = { item in
            
        }
        
        postsViewController.onUnfavorite = { item in
            
        }
        
        postsViewController.onDeleteItems = { items in
            
        }
        
        return postsViewController
    }
}

