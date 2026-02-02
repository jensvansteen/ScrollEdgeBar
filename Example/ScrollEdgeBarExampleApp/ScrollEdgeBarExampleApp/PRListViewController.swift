import UIKit
import ScrollEdgeBar

class PRListViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var edgeBarController: ScrollEdgeBarController?

    private let pullRequests: [(repo: String, title: String, labels: [String], daysAgo: Int)] = [
        ("acme / webapp", "Feat - 134 refactor onboarding flow", ["2 comments"], 3),
        ("acme / webapp", "Add automated welcome email on signup", ["Review requested", "1 eye", "pinned"], 5),
        ("acme / webapp", "Settings - redesign preferences page", ["Review requested", "2 comments", "2 eyes", "pinned"], 8),
        ("acme / webapp", "User profile editing and avatar upload", ["Review requested", "Reviews", "3 comments", "1 eye", "pinned"], 12),
        ("acme / webapp", "Feat/add-event-filters", ["Review requested", "1 eye"], 14),
        ("acme / webapp", "Feat: add blur effect to navigation bar", ["1 comment"], 18),
        ("acme / backend", "Integrate rate limiting middleware", ["Reviews", "Checks", "1 comment"], 22),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pull Requests"
        view.backgroundColor = .systemBackground

        navigationItem.largeTitleDisplayMode = .always

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: nil,
            action: nil
        )

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PRCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

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

        // Filter chips top bar
        let filterIcon = UIImageView(image: UIImage(systemName: "line.3.horizontal.decrease.circle"))
        filterIcon.tintColor = .label
        filterIcon.contentMode = .scaleAspectFit
        filterIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterIcon.widthAnchor.constraint(equalToConstant: 28),
            filterIcon.heightAnchor.constraint(equalToConstant: 28),
        ])

        let badgeLabel = UILabel()
        badgeLabel.text = "1"
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .systemBlue
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.clipsToBounds = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeLabel.widthAnchor.constraint(equalToConstant: 16),
            badgeLabel.heightAnchor.constraint(equalToConstant: 16),
        ])

        let filterContainer = UIView()
        filterContainer.addSubview(filterIcon)
        filterContainer.addSubview(badgeLabel)
        filterContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterIcon.leadingAnchor.constraint(equalTo: filterContainer.leadingAnchor),
            filterIcon.centerYAnchor.constraint(equalTo: filterContainer.centerYAnchor),
            filterContainer.trailingAnchor.constraint(equalTo: filterIcon.trailingAnchor),
            filterContainer.heightAnchor.constraint(equalToConstant: 32),
            badgeLabel.topAnchor.constraint(equalTo: filterIcon.topAnchor, constant: -4),
            badgeLabel.trailingAnchor.constraint(equalTo: filterIcon.trailingAnchor, constant: 4),
        ])

        let chips = ["Open", "Involved", "Visibility", "Org"].map { makeChip($0) }
        chips[1].backgroundColor = .systemGreen.withAlphaComponent(0.15)
        chips[1].layer.borderColor = UIColor.systemGreen.cgColor

        var allItems: [UIView] = [filterContainer]
        allItems.append(contentsOf: chips)

        let stack = UIStackView(arrangedSubviews: allItems)
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let scrollContainer = UIScrollView()
        scrollContainer.showsHorizontalScrollIndicator = false
        scrollContainer.addSubview(stack)
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            stack.heightAnchor.constraint(equalTo: scrollContainer.heightAnchor),
        ])

        let topBar = UIView()
        topBar.addSubview(scrollContainer)
        NSLayoutConstraint.activate([
            scrollContainer.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 8),
            scrollContainer.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            scrollContainer.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16),
            scrollContainer.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -8),
            scrollContainer.heightAnchor.constraint(equalToConstant: 32),
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

    private func makeChip(_ title: String) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label

        let chevron = UIImageView(image: UIImage(systemName: "chevron.down")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
        ))
        chevron.tintColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [label, chevron])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 10)

        stack.layer.cornerRadius = 16
        stack.layer.borderWidth = 0.5
        stack.layer.borderColor = UIColor.separator.cgColor
        stack.backgroundColor = .secondarySystemBackground

        return stack
    }
}

// MARK: - DataSource & Delegate

extension PRListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pullRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PRCell", for: indexPath)
        let pr = pullRequests[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = pr.title
        config.textProperties.font = .systemFont(ofSize: 15, weight: .semibold)
        config.textProperties.numberOfLines = 2

        config.secondaryText = "\(pr.repo)  ·  \(pr.daysAgo)d"
        config.secondaryTextProperties.font = .systemFont(ofSize: 13)
        config.secondaryTextProperties.color = .secondaryLabel

        config.image = UIImage(systemName: "arrow.triangle.pull")
        config.imageProperties.tintColor = .systemGreen

        cell.contentConfiguration = config
        cell.accessoryType = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
