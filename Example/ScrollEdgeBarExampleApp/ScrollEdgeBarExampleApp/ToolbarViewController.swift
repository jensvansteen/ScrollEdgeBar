import UIKit
import ScrollEdgeBar

class ToolbarViewController: UIViewController {

    private let scrollView = UIScrollView()
    private var edgeBarController: ScrollEdgeBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toolbar Demo"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        // Show system toolbar
        navigationController?.isToolbarHidden = false
        toolbarItems = [
            UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: nil),
        ]

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
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
        ])

        for i in 1...30 {
            let card = UIView()
            card.backgroundColor = .secondarySystemGroupedBackground
            card.layer.cornerRadius = 12

            let label = UILabel()
            label.text = "Item \(i)"
            label.font = .systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
                label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            ])

            stack.addArrangedSubview(card)
        }

        setupEdgeBars()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    private func setupEdgeBars() {
        let controller = ScrollEdgeBarController(scrollView: scrollView)

        // Bottom edge bar above the toolbar
        let infoLabel = UILabel()
        infoLabel.text = "30 items"
        infoLabel.font = .systemFont(ofSize: 13, weight: .medium)
        infoLabel.textColor = .secondaryLabel

        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select All", for: .normal)
        selectButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [infoLabel, spacer, selectButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let bottomBar = UIView()
        bottomBar.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -8),
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
