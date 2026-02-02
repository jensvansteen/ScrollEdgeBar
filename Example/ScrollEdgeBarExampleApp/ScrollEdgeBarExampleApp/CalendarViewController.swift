import UIKit
import ScrollEdgeBar

class CalendarViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var edgeBarController: ScrollEdgeBarController?

    private struct CalendarEvent {
        let title: String
        let startHour: Int
        let durationHours: Int
        let color: UIColor
    }

    private let hours: [String] = (0...23).map { hour in
        String(format: "%02d:00", hour)
    }

    private let events: [CalendarEvent] = [
        CalendarEvent(title: "Morning Run", startHour: 7, durationHours: 1, color: .systemGreen),
        CalendarEvent(title: "Team Standup", startHour: 9, durationHours: 1, color: .systemBlue),
        CalendarEvent(title: "Design Review", startHour: 11, durationHours: 2, color: .systemPurple),
        CalendarEvent(title: "Lunch", startHour: 13, durationHours: 1, color: .systemOrange),
        CalendarEvent(title: "Focus Time", startHour: 15, durationHours: 2, color: .systemTeal),
        CalendarEvent(title: "Gym", startHour: 18, durationHours: 1, color: .systemRed),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "February"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .singleLine
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

        let topBar = createCalendarTopBar()
        controller.setTopBar(topBar)
        controller.estimatedTopBarHeight = 90

        // Stronger blur to match the Calendar app look
        tableView.topEdgeEffect.style = .hard

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

    private func createCalendarTopBar() -> UIView {
        let container = UIView()

        // Week day row
        let weekRow = createWeekRow()
        weekRow.translatesAutoresizingMaskIntoConstraints = false

        // Date label
        let dateLabel = UILabel()
        dateLabel.text = "Tuesday – Feb 3, 2026"
        dateLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(weekRow)
        container.addSubview(dateLabel)
        container.addSubview(separator)

        NSLayoutConstraint.activate([
            weekRow.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            weekRow.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            weekRow.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: weekRow.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            separator.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    private func createWeekRow() -> UIView {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let dates = [2, 3, 4, 5, 6, 7, 8]
        let todayIndex = 1 // Tuesday the 3rd

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center

        for (index, (day, date)) in zip(days, dates).enumerated() {
            let column = UIStackView()
            column.axis = .vertical
            column.alignment = .center
            column.spacing = 2

            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.font = .systemFont(ofSize: 11, weight: .medium)
            dayLabel.textColor = index == 0 ? .systemRed : .secondaryLabel

            let dateLabel = UILabel()
            dateLabel.text = "\(date)"
            dateLabel.font = .systemFont(ofSize: 17, weight: index == todayIndex ? .bold : .regular)
            dateLabel.textAlignment = .center

            if index == todayIndex {
                let circle = UIView()
                circle.backgroundColor = .label
                circle.layer.cornerRadius = 16
                circle.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    circle.widthAnchor.constraint(equalToConstant: 32),
                    circle.heightAnchor.constraint(equalToConstant: 32),
                ])

                dateLabel.textColor = .systemBackground
                dateLabel.translatesAutoresizingMaskIntoConstraints = false
                circle.addSubview(dateLabel)
                NSLayoutConstraint.activate([
                    dateLabel.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                    dateLabel.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
                ])

                column.addArrangedSubview(dayLabel)
                column.addArrangedSubview(circle)
            } else {
                dateLabel.textColor = index == 0 ? .systemRed : .label
                column.addArrangedSubview(dayLabel)
                column.addArrangedSubview(dateLabel)

                // Match height with the circle day
                dateLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    dateLabel.heightAnchor.constraint(equalToConstant: 32),
                ])
            }

            stack.addArrangedSubview(column)
        }

        return stack
    }
}

// MARK: - DataSource

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hours.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = hours[indexPath.row]
        config.textProperties.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        config.textProperties.color = .secondaryLabel
        cell.contentConfiguration = config

        // Remove old event views
        cell.contentView.subviews.filter { $0.tag == 99 }.forEach { $0.removeFromSuperview() }

        // Add event block if one starts at this hour
        if let event = events.first(where: { $0.startHour == indexPath.row }) {
            let eventView = UIView()
            eventView.tag = 99
            eventView.backgroundColor = event.color.withAlphaComponent(0.15)
            eventView.layer.cornerRadius = 6
            eventView.layer.borderWidth = 2
            eventView.layer.borderColor = event.color.cgColor
            eventView.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel()
            label.text = event.title
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            label.textColor = event.color
            label.translatesAutoresizingMaskIntoConstraints = false
            eventView.addSubview(label)

            cell.contentView.addSubview(eventView)
            NSLayoutConstraint.activate([
                eventView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 60),
                eventView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                eventView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 2),
                eventView.heightAnchor.constraint(equalToConstant: CGFloat(event.durationHours) * 44 - 4),
                label.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 6),
                label.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 8),
            ])
            eventView.clipsToBounds = false
        }

        return cell
    }
}
