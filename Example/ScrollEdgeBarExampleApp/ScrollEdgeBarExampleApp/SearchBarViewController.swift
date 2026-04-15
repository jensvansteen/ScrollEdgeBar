import UIKit
import ScrollEdgeBar

class SearchBarViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var edgeBarController: ScrollEdgeBarController?

    private let items = (1...40).map { "Result \($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search items"
        navigationItem.searchController = searchController
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .stacked
        }
        navigationItem.hidesSearchBarWhenScrolling = false

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        setupEdgeBars()
    }

    private func setupEdgeBars() {
        let controller = ScrollEdgeBarController(scrollView: tableView)

        let segmented = UISegmentedControl(items: ["All", "Recent", "Favorites"])
        segmented.selectedSegmentIndex = 0

        let topBar = UIView()
        segmented.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(segmented)
        NSLayoutConstraint.activate([
            segmented.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 8),
            segmented.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            segmented.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16),
            segmented.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -8),
        ])
        controller.setTopBar(topBar)

        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        controller.didMove(toParent: self)
        edgeBarController = controller
    }
}

extension SearchBarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = items[indexPath.row]
        config.image = UIImage(systemName: "doc.text")
        cell.contentConfiguration = config
        return cell
    }
}

