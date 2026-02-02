import UIKit
import ScrollEdgeBar

class TransitionShowcaseViewController: UIViewController {

    private let scrollView = UIScrollView()
    private var edgeBarController: ScrollEdgeBarController?

    private let colors: [(color: UIColor, name: String)] = [
        (UIColor(red: 0.12, green: 0.12, blue: 0.18, alpha: 1), "Midnight"),
        (UIColor(red: 0.95, green: 0.94, blue: 0.90, alpha: 1), "Ivory"),
        (UIColor(red: 0.10, green: 0.18, blue: 0.28, alpha: 1), "Navy"),
        (UIColor(red: 0.96, green: 0.92, blue: 0.86, alpha: 1), "Cream"),
        (UIColor(red: 0.16, green: 0.10, blue: 0.22, alpha: 1), "Plum"),
        (UIColor(red: 0.93, green: 0.95, blue: 0.94, alpha: 1), "Mist"),
        (UIColor(red: 0.22, green: 0.10, blue: 0.10, alpha: 1), "Maroon"),
        (UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1), "Snow"),
        (UIColor(red: 0.08, green: 0.20, blue: 0.16, alpha: 1), "Forest"),
        (UIColor(red: 0.94, green: 0.90, blue: 0.86, alpha: 1), "Sand"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transition Showcase"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        for (index, item) in colors.enumerated() {
            let block = UIView()
            block.backgroundColor = item.color
            block.translatesAutoresizingMaskIntoConstraints = false
            block.heightAnchor.constraint(equalToConstant: 400).isActive = true

            let isDark = index % 2 == 0

            let label = UILabel()
            label.text = item.name
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = isDark ? .white.withAlphaComponent(0.7) : .black.withAlphaComponent(0.3)
            label.translatesAutoresizingMaskIntoConstraints = false
            block.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: block.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: block.centerYAnchor),
            ])

            stack.addArrangedSubview(block)
        }

        setupEdgeBars()
    }

    private func setupEdgeBars() {
        let controller = ScrollEdgeBarController(scrollView: scrollView)

        // Top bar: segmented control
        let segmented = UISegmentedControl(items: ["Colors", "Gradients", "Patterns"])
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

        // Bottom bar: label + switch + button
        let testLabel = UILabel()
        testLabel.text = "Test"
        testLabel.font = .systemFont(ofSize: 15, weight: .medium)

        let toggle = UISwitch()
        toggle.isOn = true

        let actionButton = UIButton(type: .system)
        actionButton.setTitle("Reset", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        actionButton.backgroundColor = .secondarySystemFill
        actionButton.layer.cornerRadius = 8
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let bottomStack = UIStackView(arrangedSubviews: [testLabel, toggle, spacer, actionButton])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 12
        bottomStack.alignment = .center
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        let bottomBar = UIView()
        bottomBar.addSubview(bottomStack)
        NSLayoutConstraint.activate([
            bottomStack.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 10),
            bottomStack.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 16),
            bottomStack.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            bottomStack.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -10),
        ])
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
}
