import UIKit

func timeNow() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss.SSS"
    return formatter.string(from: Date())
}

func logEvent(_ text: String) {
    print("\(timeNow()) | \(text)")
}

func auditAccessibility(in rootView: UIView) {
    for subview in rootView.subviews {
        if subview is UIControl {
            let hasLabel = !(subview.accessibilityLabel ?? "").isEmpty
            var hasTitle = false
            if let button = subview as? UIButton {
                hasTitle = button.currentTitle != nil || button.configuration?.title != nil
            }
            if !hasLabel && !hasTitle {
                print("Accessibility audit: missing label on \(type(of: subview))")
            }
        }
        auditAccessibility(in: subview)
    }
}

class LifecycleViewController: UIViewController {

    var screenName: String {
        return "Screen"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logEvent("\(screenName): viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logEvent("\(screenName): viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logEvent("\(screenName): viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logEvent("\(screenName): viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logEvent("\(screenName): viewDidDisappear")
    }
}

class ControlsViewController: LifecycleViewController, UITextFieldDelegate {

    override var screenName: String {
        return "Controls"
    }

    let scrollView = UIScrollView()
    let nicknameField = UITextField()
    let notifySwitch = UISwitch()
    let levelControl = UISegmentedControl(items: ["Beginner", "Medium", "Advanced"])
    let hoursSlider = UISlider()
    let hoursLabel = UILabel()
    let summaryLabel = UILabel()
    let refreshedLabel = UILabel()
    let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Controls"
        view.backgroundColor = .systemBackground

        nicknameField.placeholder = "Nickname"
        nicknameField.borderStyle = .roundedRect
        nicknameField.returnKeyType = .done
        nicknameField.delegate = self
        nicknameField.accessibilityLabel = "Nickname"
        nicknameField.addTarget(self, action: #selector(controlChanged), for: .editingChanged)

        notifySwitch.accessibilityLabel = "Notifications"
        notifySwitch.addTarget(self, action: #selector(controlChanged), for: .valueChanged)

        let notifyText = UILabel()
        notifyText.text = "Notifications"
        notifyText.font = .preferredFont(forTextStyle: .body)
        notifyText.adjustsFontForContentSizeCategory = true
        let notifyRow = UIStackView(arrangedSubviews: [notifyText, notifySwitch])
        notifyRow.distribution = .equalSpacing

        levelControl.selectedSegmentIndex = 0
        levelControl.accessibilityLabel = "Skill level"
        levelControl.addTarget(self, action: #selector(controlChanged), for: .valueChanged)

        hoursSlider.minimumValue = 0
        hoursSlider.maximumValue = 10
        hoursSlider.value = 2
        hoursSlider.accessibilityLabel = "Study hours per day"
        hoursSlider.addTarget(self, action: #selector(controlChanged), for: .valueChanged)

        hoursLabel.font = .preferredFont(forTextStyle: .body)
        hoursLabel.adjustsFontForContentSizeCategory = true

        summaryLabel.numberOfLines = 0
        summaryLabel.font = .preferredFont(forTextStyle: .body)
        summaryLabel.adjustsFontForContentSizeCategory = true

        let summaryPanel = UIView()
        summaryPanel.backgroundColor = .secondarySystemBackground
        summaryPanel.layer.cornerRadius = 10
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryPanel.addSubview(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: summaryPanel.topAnchor, constant: 12),
            summaryLabel.bottomAnchor.constraint(equalTo: summaryPanel.bottomAnchor, constant: -12),
            summaryLabel.leadingAnchor.constraint(equalTo: summaryPanel.leadingAnchor, constant: 12),
            summaryLabel.trailingAnchor.constraint(equalTo: summaryPanel.trailingAnchor, constant: -12)
        ])

        refreshedLabel.font = .preferredFont(forTextStyle: .footnote)
        refreshedLabel.textColor = .secondaryLabel
        refreshedLabel.adjustsFontForContentSizeCategory = true

        nextButton.setTitle("Open Next Screen", for: .normal)
        nextButton.addTarget(self, action: #selector(openNext), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nicknameField, notifyRow, levelControl,
                                                   hoursLabel, hoursSlider, summaryPanel,
                                                   refreshedLabel, nextButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])

        updateSummary()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSummary()
        refreshedLabel.text = "Summary refreshed at \(timeNow())"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        auditAccessibility(in: view)
    }

    @objc func controlChanged() {
        updateSummary()
    }

    func updateSummary() {
        let typed = nicknameField.text ?? ""
        let nickname = typed.isEmpty ? "(no nickname)" : typed
        let notifications = notifySwitch.isOn ? "On" : "Off"
        let level = levelControl.titleForSegment(at: levelControl.selectedSegmentIndex) ?? "None"
        let hours = Int(hoursSlider.value.rounded())

        hoursLabel.text = "Study hours per day: \(hours)"
        summaryLabel.text = "Nickname: \(nickname)\nNotifications: \(notifications)\nLevel: \(level)\nStudy hours: \(hours)"
    }

    @objc func openNext() {
        navigationController?.pushViewController(NextScreenViewController(), animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class NextScreenViewController: LifecycleViewController {

    override var screenName: String {
        return "Next"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Next Screen"
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "This is the next screen"
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
