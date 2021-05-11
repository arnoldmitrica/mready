
import UIKit


class RepoListVC: GFDataLoadingVC {
    
    enum Section {
        case main
    }
    
    var query: String!
    var repositories: [Item] = []
    var filteredRepositories: [Item] = []
    var page = 1
    var noMoreRepositories:Bool {
        didSet{
            print("no more repo")
        }
    }
    var isSearching = false
    var isLoadingMoreRepositories = false
    
    var collectionView: UICollectionView!
    var dataSource: UITableViewDiffableDataSource<Section, Item>!
    
    init(query: String) {
        noMoreRepositories = false
        super.init(nibName: nil, bundle: nil)
        //noMoreRepositories = false
        self.query = query
        title = query
        
        //configureViewController()

    }
    
//    required init?(coder: NSCoder) {
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder: NSCoder) {
        noMoreRepositories = false
        super.init(coder: coder)
    }
    
//    required init?(coder: NSCoder) {
//        //super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // configureCollectionView()
        configureViewController()

        getRepositories(query: query, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) // shows animation instead of just hiding it
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
       navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNvc))
        //navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNvc))
        //navigationController?.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNvc)), animated: false)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cancelNvc))
        self.navigationController?.navigationItem.rightBarButtonItem = addButton
        //navigationController?.navigationItem.rightBarButtonItem = addButton
        
    }
    
    func getRepositories(query: String, page: Int) {
        showLoadingView()
        isLoadingMoreRepositories = true
        NetworkManager.shared.getRepositories(for: query, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let repositoriesItems):
                self.repositories.append(contentsOf: repositoriesItems.items)
                if self.repositories.count > 89 { self.noMoreRepositories = true }
                if self.repositories.isEmpty {
                    let message = "This query doesn't have any repositories"
                    
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                self.updateData(on: self.repositories)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonTitle: "OK")
            }
            self.isLoadingMoreRepositories = false
        }
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: {(tableView, indexPath,item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseID, for: indexPath) as? RepositoryCell
            cell?.configureCell(with: RepositoryCellViewModel(with: item))
            return cell
        })
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search from repositories description"
        searchController.obscuresBackgroundDuringPresentation = false // removes light overlay on results below
        navigationItem.searchController = searchController
        
    }
    
    func updateData(on repositories: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repositories)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: false) }
    }
    
    
    deinit {
        print("RepoListVC has deinit")
    }
}

extension RepoListVC {
    
    /// shows when a scroll view is done dragging
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
//        print("offset: \(offsetY)")
//        print("contentheight: \(contentHeight)")
//        print("height: \(height)")
        
        if offsetY > contentHeight - height {
            print(noMoreRepositories,isLoadingMoreRepositories)
            guard noMoreRepositories == false, isLoadingMoreRepositories == false else {
                self.presentGFAlertOnMainThread(title: "Where you at?", message: "There is a limit of max 100 repositories", buttonTitle: "Ok")
                return }
            
            page += 1
            getRepositories(query: query, page: page)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // a way to aleternate on an array
        let activeArray = isSearching ? filteredRepositories : repositories
        let item = activeArray[indexPath.row]
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailVC") as DetailViewController
        //let item = repositories[indexPath.row]
        detailVC.viewModel = RepositoryDetailViewModel(fullName: item.fullName, itemDescription: item.itemDescription ?? "No description", language: item.language, avatarOwnerURL: item.owner.avatarURL, ownerName: item.owner.login, forkCount: item.forksCount, stargazersCount: item.stargazersCount, updatedAt: item.updatedAt)
        self.navigationController?.pushViewController(detailVC, animated: false)
    }
    
    @objc func cancelNvc(){
        print("dada")
        dismiss(animated: true, completion: nil)
    }
}


extension RepoListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // make sure have text
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else {
            filteredRepositories.removeAll()
            updateData(on: repositories)
            isSearching = false
            return
        }
        
        isSearching = true
        // uses two arrays to control which array to show at a given moment
        filteredRepositories = repositories.filter { ($0.itemDescription?.lowercased().contains(filter.lowercased()) ?? false)}
        
        updateData(on: filteredRepositories)
    }
}
