import UIKit
import ScrollEdgeBar

class PRDetailViewController: UIViewController {

    private let scrollView = UIScrollView()
    private var edgeBarController: ScrollEdgeBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add welcome email on..."
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemGroupedBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let content = buildContent()
        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scrollView.topAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        setupEdgeBars()
    }

    // MARK: - Edge Bars

    private func setupEdgeBars() {
        let controller = ScrollEdgeBarController(scrollView: scrollView)

        // Top bar: review requested banner
        let topBar = makeTopBar()
        controller.setTopBar(topBar)

        // Bottom bar: comment + info buttons on the right
        let bottomBar = makeBottomBar()
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

    private func makeTopBar() -> UIView {
        let icon = UIImageView(image: UIImage(systemName: "person.crop.circle.badge.plus")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 18)
        ))
        icon.tintColor = .systemOrange

        let label = UILabel()
        label.text = "alexjohnson requested your review"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [label])
        textStack.axis = .vertical

        var reviewConfig = UIButton.Configuration.filled()
        reviewConfig.title = "Review"
        reviewConfig.cornerStyle = .capsule
        reviewConfig.buttonSize = .small
        let reviewButton = UIButton(configuration: reviewConfig)
        reviewButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [icon, textStack, reviewButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let glassEffect = UIGlassEffect(style: .clear)
        glassEffect.tintColor = UIColor(hex: "#428443").withAlphaComponent(0.30)
        let glass = UIVisualEffectView(effect: glassEffect)
        glass.layer.cornerRadius = 24
        glass.contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: glass.contentView.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: glass.contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: glass.contentView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: glass.contentView.bottomAnchor, constant: -10),
        ])

        let wrapper = UIView()
        glass.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview(glass)
        NSLayoutConstraint.activate([
            glass.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 8),
            glass.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 16),
            glass.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -16),
            glass.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -8),
        ])
        return wrapper
    }

    private func makeBottomBar() -> UIView {
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.configuration = .clearGlass()
        let commentButton = UIButton(type: .custom)
        commentButton.configuration = .clearGlass()
        commentButton.setTitle("Comment", for: .normal)

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [spacer, commentButton, infoButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let bar = UIView()
        bar.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: bar.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bar.bottomAnchor, constant: -10),
        ])
        return bar
    }

    private func makeGlassButton(title: String?, icon: String) -> UIView {
        let glass = UIVisualEffectView(effect: UIGlassEffect(style: .clear))
        glass.layer.cornerRadius = 18


        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit

        var items: [UIView] = [imageView]
        if let title {
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = .label
            items.append(label)
        }

        let stack = UIStackView(arrangedSubviews: items)
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        glass.contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: glass.contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: glass.contentView.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: glass.contentView.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: glass.contentView.bottomAnchor, constant: -8),
        ])

        return glass
    }

    // MARK: - Content

    private func buildContent() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0

        // Changes section
        stack.addArrangedSubview(makeSectionHeader("Changes"))
        stack.addArrangedSubview(makeRow(
            icon: "doc.badge.plus",
            title: "3 files changed",
            detail: "+52 -40",
            detailColor: .label
        ))
        stack.addArrangedSubview(makeSeparator())
        stack.addArrangedSubview(makeRow(
            icon: "circle.and.line.horizontal",
            title: "1 commit",
            detail: "10 days ago",
            detailColor: .secondaryLabel
        ))

        // Status section
        stack.addArrangedSubview(makeSectionHeader("Status"))
        stack.addArrangedSubview(makeReviewsRow())
        stack.addArrangedSubview(makeSeparator())
        stack.addArrangedSubview(makeMergeSection())

        // Conversation section
        stack.addArrangedSubview(makeSectionHeader("Conversation"))
        for i in 1...5 {
            stack.addArrangedSubview(makeConversationRow("Comment \(i) — Discussion about the implementation details"))
            stack.addArrangedSubview(makeSeparator())
        }

        // Extra padding at bottom
        let bottomSpacer = UIView()
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stack.addArrangedSubview(bottomSpacer)

        return stack
    }

    private func makeSectionHeader(_ title: String) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)

        let container = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
        ])
        return container
    }

    private func makeRow(icon: String, title: String, detail: String, detailColor: UIColor) -> UIView {
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 22),
        ])

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15)

        let detailLabel = UILabel()
        detailLabel.text = detail
        detailLabel.font = .systemFont(ofSize: 15)
        detailLabel.textColor = detailColor

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        ))
        chevron.tintColor = .tertiaryLabel

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, spacer, detailLabel, chevron])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
        ])
        return container
    }

    private func makeReviewsRow() -> UIView {
        let circle = UIView()
        circle.backgroundColor = .systemGray4
        circle.layer.cornerRadius = 8
        circle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalToConstant: 16),
            circle.heightAnchor.constraint(equalToConstant: 16),
        ])

        let label = UILabel()
        label.text = "Reviews"
        label.font = .systemFont(ofSize: 15)

        let chevron = UIImageView(image: UIImage(systemName: "chevron.up")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        ))
        chevron.tintColor = .tertiaryLabel

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [circle, label, spacer, chevron])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Your Review", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.backgroundColor = .secondarySystemFill
        addButton.layer.cornerRadius = 10
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let vstack = UIStackView(arrangedSubviews: [stack, addButton])
        vstack.axis = .vertical
        vstack.spacing = 12
        vstack.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.addSubview(vstack)
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            vstack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            vstack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            vstack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
        ])
        return container
    }

    private func makeMergeSection() -> UIView {
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmark.tintColor = .systemGreen
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkmark.widthAnchor.constraint(equalToConstant: 22),
            checkmark.heightAnchor.constraint(equalToConstant: 22),
        ])

        let title = UILabel()
        title.text = "Ready to merge"
        title.font = .systemFont(ofSize: 16, weight: .semibold)

        let subtitle = UILabel()
        subtitle.text = "This branch has no conflicts with the base branch."
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 4

        let headerStack = UIStackView(arrangedSubviews: [checkmark, textStack])
        headerStack.axis = .horizontal
        headerStack.spacing = 10
        headerStack.alignment = .top

        let mergeButton = UIButton(type: .system)
        mergeButton.setTitle("Merge Pull Request", for: .normal)
        mergeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        mergeButton.setTitleColor(.white, for: .normal)
        mergeButton.backgroundColor = .systemGreen
        mergeButton.layer.cornerRadius = 10
        mergeButton.translatesAutoresizingMaskIntoConstraints = false
        mergeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .secondaryLabel
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        settingsButton.backgroundColor = .secondarySystemFill
        settingsButton.layer.cornerRadius = 10

        let buttonStack = UIStackView(arrangedSubviews: [mergeButton, settingsButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8

        let vstack = UIStackView(arrangedSubviews: [headerStack, buttonStack])
        vstack.axis = .vertical
        vstack.spacing = 16
        vstack.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.backgroundColor = .systemGreen.withAlphaComponent(0.08)
        container.addSubview(vstack)
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            vstack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            vstack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            vstack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
        ])
        return container
    }

    private func makeSeparator() -> UIView {
        let sep = UIView()
        sep.backgroundColor = .separator
        sep.translatesAutoresizingMaskIntoConstraints = false
        sep.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        return sep
    }

    private func makeConversationRow(_ text: String) -> UIView {
        let avatar = UIView()
        avatar.backgroundColor = .systemGray3
        avatar.layer.cornerRadius = 14
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 28),
            avatar.heightAnchor.constraint(equalToConstant: 28),
        ])

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [avatar, label])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
        ])
        return container
    }
}
