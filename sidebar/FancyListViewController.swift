//
//  FancyListViewController.swift
//  sidebar
//
//  Created by Alex Logan on 08/10/2020.
//
import Foundation
import UIKit

protocol FancyListViewControllerDelegate: class {
    func fancyListViewControllerDidSelectItem(_ vc: FancyListViewController, itemIdentifier: FancyListItemIdentifier)
}

class FancyListViewController: UIViewController {
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<FancyListSectionIdentifier, FancyListItem>?
    let sections = [FancyListSection.main, FancyListSection.secondary]
    weak var delegate: FancyListViewControllerDelegate?
    let accentColor: UIColor = .systemPink
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        layout()
  
        #if targetEnvironment(macCatalyst)
        updateForMac()
        #else
        updateStyles()
        #endif
    }
    
    func updateStyles() {
        navigationItem.title = "Fancy List"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = accentColor
        view.backgroundColor = UIColor.systemBackground
    }
    
    func updateForMac() {
        view.backgroundColor = .clear
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateList()
        if collectionView?.indexPathsForSelectedItems?.count == 0 {
            collectionView?.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    func setupCollectionView() {
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.backgroundColor = UIColor.clear
        config.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collectionView
        self.dataSource = makeDataSource()
        // Delegates
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
    }
    
    func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension FancyListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if let identifier = section.items[indexPath.row-1].identifier {
            delegate?.fancyListViewControllerDidSelectItem(self, itemIdentifier: identifier)
        }
    }
}

private extension FancyListViewController {
    func makeHeaderRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, FancyListItem> {
        UICollectionView.CellRegistration { cell, index, fancyListItem in
            var config = UIListContentConfiguration.sidebarHeader()
            config.text = fancyListItem.text
            config.textProperties.font = .systemFont(ofSize: 14, weight: .medium)
            cell.contentConfiguration = config
            cell.tintColor = self.accentColor
        }
    }
    
    func makeExpandableHeaderRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, FancyListItem> {
        UICollectionView.CellRegistration { cell, index, fancyListItem in
            var config = UIListContentConfiguration.sidebarHeader()
            config.text = fancyListItem.text
            config.textProperties.font = .systemFont(ofSize: 14, weight: .medium)
            cell.contentConfiguration = config
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
            cell.tintColor = self.accentColor
        }
    }
    
    func makeRowRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, FancyListItem> {
        UICollectionView.CellRegistration { cell, index, fancyListItem in
            var config = UIListContentConfiguration.sidebarCell()
            if let imageName = fancyListItem.imageName {
                config.image = UIImage(systemName: imageName)
            }
            config.text = fancyListItem.text
            cell.contentConfiguration = config
            cell.tintColor = self.accentColor
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<FancyListSectionIdentifier, FancyListItem> {
        let expandableHeaderRegistration = makeExpandableHeaderRegistration()
        let headerRegistration = makeHeaderRegistration()
        let rowRegistration = makeRowRegistration()
        
        return UICollectionViewDiffableDataSource<FancyListSectionIdentifier, FancyListItem>(
            collectionView: collectionView!,
            cellProvider: { view, indexPath, item in
                switch item.type {
                case .expandableHeader:
                    return view.dequeueConfiguredReusableCell(
                        using: expandableHeaderRegistration,
                        for: indexPath,
                        item: item
                    )
                case .header:
                    return view.dequeueConfiguredReusableCell(
                        using: headerRegistration,
                        for: indexPath,
                        item: item
                    )
                case .row:
                    return view.dequeueConfiguredReusableCell(
                        using: rowRegistration,
                        for: indexPath,
                        item: item
                    )
                }
            }
        )
    }
    
    func updateList() {
        sections.forEach { section in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<FancyListItem>()
            sectionSnapshot.append([section.header])
            sectionSnapshot.append(section.items, to: section.header)
            sectionSnapshot.expand([section.header])
            
            dataSource?.apply(sectionSnapshot, to: section.identifier)
        }
    }
}
