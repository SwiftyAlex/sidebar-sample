//
//  PlaceholderViewController.swift
//  sidebar
//
//  Created by Alex Logan on 08/12/2020.
//

import Foundation
import UIKit

class PlaceholderViewController: UIViewController {
    let label: UILabel = UILabel()
    var content: String = "Select an item" {
        didSet {
            label.text = content
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorate()
        configureLabel()
        layout()
    }
    
    func decorate() {
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.tintColor = .systemPink
        navigationController?.navigationBar.barTintColor = .systemGroupedBackground
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.text = content
    }
    
    func layout() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
