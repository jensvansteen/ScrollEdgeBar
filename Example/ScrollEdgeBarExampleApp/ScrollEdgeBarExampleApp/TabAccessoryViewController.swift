import UIKit
import ScrollEdgeBar

class TabAccessoryViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var edgeBarController: ScrollEdgeBarController?

    private let songs = [
        ("Blinding Lights", "The Weeknd"),
        ("Levitating", "Dua Lipa"),
        ("Stay", "The Kid LAROI & Justin Bieber"),
        ("Good 4 U", "Olivia Rodrigo"),
        ("Peaches", "Justin Bieber ft. Daniel Caesar"),
        ("Montero", "Lil Nas X"),
        ("Kiss Me More", "Doja Cat ft. SZA"),
        ("Save Your Tears", "The Weeknd & Ariana Grande"),
        ("Drivers License", "Olivia Rodrigo"),
        ("Butter", "BTS"),
        ("Heat Waves", "Glass Animals"),
        ("Industry Baby", "Lil Nas X & Jack Harlow"),
        ("Shivers", "Ed Sheeran"),
        ("Easy On Me", "Adele"),
        ("Happier Than Ever", "Billie Eilish"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Now Playing"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

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

        setupTabAccessory()
        setupEdgeBars()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.bottomAccessory = nil
    }

    private func setupTabAccessory() {
        let accessoryView = NowPlayingAccessoryView()
        accessoryView.translatesAutoresizingMaskIntoConstraints = false

        let accessory = UITabAccessory(contentView: accessoryView)
        tabBarController?.bottomAccessory = accessory
    }

    private func setupEdgeBars() {
        let controller = ScrollEdgeBarController(scrollView: tableView)

        let segmented = UISegmentedControl(items: ["All Songs", "Albums", "Artists"])
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

// MARK: - DataSource

extension TabAccessoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let song = songs[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = song.0
        config.secondaryText = song.1
        config.image = UIImage(systemName: "music.note")
        config.imageProperties.tintColor = .systemPink
        cell.contentConfiguration = config
        return cell
    }
}

// MARK: - Now Playing Accessory View

private class NowPlayingAccessoryView: UIView {

    private let artworkView = UIView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let playButton = UIButton(type: .system)
    private let forwardButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        artworkView.backgroundColor = .systemPink.withAlphaComponent(0.3)
        artworkView.layer.cornerRadius = 6
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artworkView.widthAnchor.constraint(equalToConstant: 36),
            artworkView.heightAnchor.constraint(equalToConstant: 36),
        ])

        let noteIcon = UIImageView(image: UIImage(systemName: "music.note"))
        noteIcon.tintColor = .systemPink
        noteIcon.contentMode = .scaleAspectFit
        noteIcon.translatesAutoresizingMaskIntoConstraints = false
        artworkView.addSubview(noteIcon)
        NSLayoutConstraint.activate([
            noteIcon.centerXAnchor.constraint(equalTo: artworkView.centerXAnchor),
            noteIcon.centerYAnchor.constraint(equalTo: artworkView.centerYAnchor),
            noteIcon.widthAnchor.constraint(equalToConstant: 18),
            noteIcon.heightAnchor.constraint(equalToConstant: 18),
        ])

        titleLabel.text = "Blinding Lights"
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label

        artistLabel.text = "The Weeknd"
        artistLabel.font = .systemFont(ofSize: 12)
        artistLabel.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        textStack.axis = .vertical
        textStack.spacing = 1

        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)), for: .normal)
        playButton.tintColor = .label

        forwardButton.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14)), for: .normal)
        forwardButton.tintColor = .label

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [artworkView, textStack, spacer, playButton, forwardButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
