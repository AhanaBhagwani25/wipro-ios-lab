import UIKit

struct ProfileValidator {

    static func nameError(_ name: String) -> String? {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return "Name is required"
        }
        if trimmed.count < 2 {
            return "Name must be at least 2 characters"
        }
        return nil
    }

    static func emailError(_ email: String) -> String? {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return "Email is required"
        }
        let parts = trimmed.split(separator: "@", omittingEmptySubsequences: false)
        if trimmed.contains(" ") || parts.count != 2 || parts[0].isEmpty {
            return "Enter a valid email address"
        }
        let domain = parts[1]
        if !domain.contains(".") || domain.hasPrefix(".") || domain.hasSuffix(".") {
            return "Enter a valid email address"
        }
        return nil
    }

    static func courseError(_ course: String) -> String? {
        let trimmed = course.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return "Please choose a course"
        }
        return nil
    }
}

class ProfileFormViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    let courses = ["Computer Science", "Information Technology", "Electronics", "Mechanical"]

    let scrollView = UIScrollView()
    let nameField = UITextField()
    let emailField = UITextField()
    let courseField = UITextField()
    let nameError = UILabel()
    let emailError = UILabel()
    let courseError = UILabel()
    let submitButton = UIButton(type: .system)
    let coursePicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile Form"
        view.backgroundColor = .systemBackground

        nameField.placeholder = "Enter your full name"
        nameField.textContentType = .name
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = .next

        emailField.placeholder = "Enter your email"
        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .next

        courseField.placeholder = "Choose your course"
        coursePicker.dataSource = self
        coursePicker.delegate = self
        courseField.inputView = coursePicker

        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Submit"
        submitButton.configuration = buttonConfig
        submitButton.accessibilityLabel = "Submit profile"
        submitButton.accessibilityHint = "Checks the form and saves the profile"
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        let nameGroup = makeGroup(title: "Name", field: nameField, errorLabel: nameError)
        let emailGroup = makeGroup(title: "Email", field: emailField, errorLabel: emailError)
        let courseGroup = makeGroup(title: "Course", field: courseField, errorLabel: courseError)

        let stack = UIStackView(arrangedSubviews: [nameGroup, emailGroup, courseGroup, submitButton])
        stack.axis = .vertical
        stack.spacing = 20
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func makeGroup(title: String, field: UITextField, errorLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true

        field.borderStyle = .roundedRect
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.delegate = self
        field.accessibilityLabel = title

        errorLabel.font = .preferredFont(forTextStyle: .caption1)
        errorLabel.adjustsFontForContentSizeCategory = true
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        let group = UIStackView(arrangedSubviews: [titleLabel, field, errorLabel])
        group.axis = .vertical
        group.spacing = 6
        return group
    }

    func show(_ message: String?, on label: UILabel) {
        label.text = message
        label.isHidden = (message == nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func submitTapped() {
        view.endEditing(true)

        let nameMessage = ProfileValidator.nameError(nameField.text ?? "")
        let emailMessage = ProfileValidator.emailError(emailField.text ?? "")
        let courseMessage = ProfileValidator.courseError(courseField.text ?? "")

        show(nameMessage, on: nameError)
        show(emailMessage, on: emailError)
        show(courseMessage, on: courseError)

        if nameMessage == nil && emailMessage == nil && courseMessage == nil {
            let summary = "Name: \(nameField.text ?? "")\nEmail: \(emailField.text ?? "")\nCourse: \(courseField.text ?? "")"
            let alert = UIAlertController(title: "Profile saved", message: summary, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            UIAccessibility.post(notification: .announcement, argument: "Please fix the errors in the form")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            courseField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == courseField && (courseField.text ?? "").isEmpty {
            courseField.text = courses[0]
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        courseField.text = courses[row]
    }
}
