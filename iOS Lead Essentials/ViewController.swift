//
//  ViewController.swift
//  iOS Lead Essentials
//
//  Created by Oleksandr Balan on 2021-08-25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginVC = segue.destination as? LoginViewController {
            loginVC.login = ApiClient.shared.login
        }
        if let feedVC = segue.destination as? FeedViewController {
            feedVC.getFeed = ApiClient.shared.getFeed
        }
    }
}

struct User {}
struct FeedItem {}

// Main Module
extension ApiClient {
    func login(completion: (User?) -> Void) {}
}

extension ApiClient {
    func getFeed(completion: ([FeedItem]) -> Void) {}
}

// API Module
class ApiClient {
    static let shared = ApiClient()
    
    private init() {}
    
    func execute(_ request: URLRequest, completion: @escaping (Data?) -> Void) {}
}

// Test Module
class MockApiClient: ApiClient {}

// Login Module
class LoginViewController: UIViewController {
    var login: (((User?) -> Void) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didTapLogin() {
        login? { user in
            // show user
        }
    }
}

// Feed Module
class FeedViewController: UIViewController {
    var getFeed: ((([FeedItem]) -> Void) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didTapGetFeed() {
        getFeed? { feedItems in
            // show feed items
        }
    }
}
