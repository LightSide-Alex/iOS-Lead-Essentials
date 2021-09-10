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
            loginVC.worker = ApiClient.shared
        }
        if let feedVC = segue.destination as? FeedViewController {
            feedVC.worker = ApiClient.shared
        }
    }
}

struct User {}
struct FeedItem {}

// Main Module
extension ApiClient: LoginWorker {
    func login(completion: (User?) -> Void) {}
}

extension ApiClient: FeedWorker {
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
protocol LoginWorker {
    func login(completion: (User?) -> Void)
}

class LoginViewController: UIViewController {
    var worker: LoginWorker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didTapLogin() {
        worker?.login { user in
            // show user
        }
    }
}

// Feed Module
protocol FeedWorker {
    func getFeed(completion: ([FeedItem]) -> Void)
}

class FeedViewController: UIViewController {
    var worker: FeedWorker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didTapGetFeed() {
        worker?.getFeed { feedItems in
            // show feed items
        }
    }
}

protocol TestInterface: UITableViewCell {
    func kek()
}

class TestImplementation: UITableViewCell, TestInterface {
    func kek() {
        print("DO KEK")
    }
}
