import UIKit
import ScrollEdgeBar

class AppStoreListingViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var edgeBarController: ScrollEdgeBarController?

    private let apps: [(name: String, subtitle: String, color: UIColor, action: String)] = [
        ("Birdy", "Your daily companion", .systemMint, "Open"),
        ("Chatterbox", "Talk freely with friends", .green, "Open"),
        ("Lensify", "AI-powered photo search", .systemBlue, "Open"),
        ("BargainHunt", "Find the best deals around", .orange, "Open"),
        ("FreshCart", "Groceries delivered fast", .red, "Get"),
        ("Boutique", "Discover unique brands", .purple, "Open"),
        ("ClipCraft", "Edit videos like a pro", .black, "Get"),
        ("Ridely", "Get there in minutes", .systemTeal, "Open"),
        ("Streamr", "Movies, shows & more", .systemIndigo, "Open"),
        ("Loopback", "Share thoughts & ideas", .black, "Open"),
        ("Pixelgram", "Photos & Stories", .systemPink, "Open"),
        ("Vibes", "Short videos & music", .systemCyan, "Open"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Downloaded"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AppCell.self, forCellReuseIdentifier: "AppCell")
        tableView.rowHeight = 80

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

        let segmented = UISegmentedControl(items: ["Free Apps", "Paid Apps"])
        segmented.selectedSegmentIndex = 0
        segmented.translatesAutoresizingMaskIntoConstraints = false

        let topBar = UIView()
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

// MARK: - DataSource & Delegate

extension AppStoreListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! AppCell
        let app = apps[indexPath.row]
        cell.configure(rank: indexPath.row + 1, name: app.name, subtitle: app.subtitle, color: app.color, action: app.action)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AppCell

private class AppCell: UITableViewCell {
    private let rankLabel = UILabel()
    private let iconView = UIView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        rankLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        rankLabel.textColor = .label
        rankLabel.textAlignment = .center
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true

        iconView.layer.cornerRadius = 12
        iconView.layer.cornerCurve = .continuous
        iconView.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 52),
            iconView.heightAnchor.constraint(equalToConstant: 52),
        ])

        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.numberOfLines = 1
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        let textStack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        actionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        actionButton.backgroundColor = .systemGray5
        actionButton.layer.cornerRadius = 14
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        let mainStack = UIStackView(arrangedSubviews: [rankLabel, iconView, textStack, actionButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(rank: Int, name: String, subtitle: String, color: UIColor, action: String) {
        rankLabel.text = "\(rank)"
        iconView.backgroundColor = color
        nameLabel.text = name
        subtitleLabel.text = subtitle
        actionButton.setTitle(action, for: .normal)
    }
}
