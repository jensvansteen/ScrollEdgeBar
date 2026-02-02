import UIKit
import ScrollEdgeBar

class TabAccessoryViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var edgeBarController: ScrollEdgeBarController?

    private let songs = [
        ("Neon Skyline", "Luna Park"),
        ("Elevate", "Mira Cole"),
        ("Drift Away", "Echo & The Waves"),
        ("Golden Hour", "Sage Rivera"),
        ("Afterglow", "Felix Hart ft. Nova Chen"),
        ("Wildfire", "Kai Lumen"),
        ("Closer Still", "Vera Lin ft. Arlo"),
        ("Midnight Rain", "Luna Park & Celeste Voss"),
        ("Open Road", "Sage Rivera"),
        ("Sunrise", "Prism"),
        ("Slow Burn", "Amber Dunes"),
        ("Neon Dreams", "Kai Lumen & Theo Blake"),
        ("Electric", "Owen Marsh"),
        ("Let It Go", "Clara Veil"),
        ("Better Days", "Ivy Sinclair"),
        ("Paper Planes", "Marcus Wren"),
        ("Sidetrack", "Elara Moon"),
        ("Freefall", "Jasper Cole & Rue Kim"),
        ("About Time", "Delia Ray"),
        ("Old Habits", "Sam Vega"),
        ("Uphill", "Fern Holloway"),
        ("No Worries", "Solaris"),
        ("Easy Breeze", "Rio & Maya Sol"),
        ("Petals", "Jolie West"),
        ("Switchblade", "Arlo"),
        ("Lurking", "Onyx ft. Luna Park"),
        ("Half Truth", "Rosie Fawn & Neve"),
        ("Nocturnal", "Sage Rivera"),
        ("Color Splash", "Vera Lin"),
        ("Hot Pavement", "Elara Moon"),
        ("Daydream", "Arlo"),
        ("Late Call", "Beck Wilder"),
        ("Morning Buzz", "Hazel Bright"),
        ("Wanting More", "Jules Avery"),
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

        tabBarController?.tabBarMinimizeBehavior = .onScrollDown
        setupTabAccessory()
        setupEdgeBars()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.bottomAccessory = nil
        tabBarController?.tabBarMinimizeBehavior = .never
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

        let bottomBar = createBottomBar()
        controller.setBottomBar(bottomBar)

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

    private func createBottomBar() -> UIView {
        let container = UIView()

        let shuffleButton = UIButton(type: .system)
        shuffleButton.setImage(UIImage(systemName: "shuffle"), for: .normal)
        shuffleButton.setTitle(" Shuffle", for: .normal)
        shuffleButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

        let repeatButton = UIButton(type: .system)
        repeatButton.setImage(UIImage(systemName: "repeat"), for: .normal)
        repeatButton.setTitle(" Repeat", for: .normal)
        repeatButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [shuffleButton, spacer, repeatButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
        ])

        return container
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
    private let textStack = UIStackView()
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

        titleLabel.text = "Neon Skyline"
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label

        artistLabel.text = "Luna Park"
        artistLabel.font = .systemFont(ofSize: 12)
        artistLabel.textColor = .secondaryLabel

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(artistLabel)
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

        registerForTraitChanges([UITraitTabAccessoryEnvironment.self]) { (self: NowPlayingAccessoryView, _: UITraitCollection) in
            self.updateForEnvironment()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    private func updateForEnvironment() {
        let isInline = traitCollection.tabAccessoryEnvironment == .inline

        artworkView.isHidden = isInline
        artistLabel.isHidden = isInline
        forwardButton.isHidden = isInline
    }
}
