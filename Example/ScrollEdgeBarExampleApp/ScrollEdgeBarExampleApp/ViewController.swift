import UIKit

class ViewController: UITableViewController {

    private let demos: [(title: String, subtitle: String, icon: String)] = [
        ("App Store Listing", "Segmented control top bar", "bag"),
        ("Pull Requests", "Filter chips with large title", "arrow.triangle.pull"),
        ("PR Detail", "Review banner + action buttons", "text.page.badge.magnifyingglass"),
        ("Transition Showcase", "Color blocks showing glass blur", "paintpalette"),
        ("Toolbar", "Edge bar above system toolbar", "hammer"),
        ("Search Bar", "Search controller + segmented control", "magnifyingglass"),
        ("Tab Accessory", "Inline & expanded bottom accessory", "music.note.list"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ScrollEdgeBar"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: - DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let demo = demos[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = demo.title
        config.secondaryText = demo.subtitle
        config.image = UIImage(systemName: demo.icon)
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: UIViewController
        switch indexPath.row {
        case 0: vc = AppStoreListingViewController()
        case 1: vc = PRListViewController()
        case 2: vc = PRDetailViewController()
        case 3: vc = TransitionShowcaseViewController()
        case 4: vc = ToolbarViewController()
        case 5: vc = SearchBarViewController()
        case 6: vc = TabAccessoryViewController()
        default: return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
