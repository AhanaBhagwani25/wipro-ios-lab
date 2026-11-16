import UIKit

struct Student {
    let name: String
    let course: String
    let marks: Int
}

class StudentCell: UITableViewCell {

    static let reuseID = "StudentCell"

    let nameLabel = UILabel()
    let courseLabel = UILabel()
    let marksLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        courseLabel.font = .preferredFont(forTextStyle: .subheadline)
        courseLabel.textColor = .secondaryLabel
        marksLabel.font = .preferredFont(forTextStyle: .title3)

        let textStack = UIStackView(arrangedSubviews: [nameLabel, courseLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        marksLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textStack)
        contentView.addSubview(marksLabel)

        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            marksLabel.leadingAnchor.constraint(greaterThanOrEqualTo: textStack.trailingAnchor, constant: 8),
            marksLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            marksLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with student: Student) {
        nameLabel.text = student.name
        courseLabel.text = student.course
        marksLabel.text = "\(student.marks)"
    }
}

class StudentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let sampleStudents = [
        Student(name: "Riya Sharma", course: "Computer Science", marks: 88),
        Student(name: "Aman Verma", course: "Information Technology", marks: 76),
        Student(name: "Neha Singh", course: "Electronics", marks: 91),
        Student(name: "Karan Gupta", course: "Computer Science", marks: 67)
    ]

    var students: [Student] = []

    let tableView = UITableView()
    let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Students"
        view.backgroundColor = .systemBackground

        students = sampleStudents

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain,
                                                            target: self, action: #selector(toggleData))

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        emptyLabel.text = "No students to show"
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .preferredFont(forTextStyle: .title3)
        emptyLabel.adjustsFontForContentSizeCategory = true
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        refreshScreen()
    }

    func refreshScreen() {
        emptyLabel.isHidden = !students.isEmpty
        tableView.isHidden = students.isEmpty
        navigationItem.rightBarButtonItem?.title = students.isEmpty ? "Load" : "Clear"
        tableView.reloadData()
    }

    @objc func toggleData() {
        if students.isEmpty {
            students = sampleStudents
        } else {
            students = []
        }
        refreshScreen()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseID, for: indexPath) as? StudentCell else {
            return UITableViewCell()
        }
        cell.configure(with: students[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailScreen = StudentDetailViewController()
        detailScreen.student = students[indexPath.row]
        navigationController?.pushViewController(detailScreen, animated: true)
    }
}

class StudentDetailViewController: UIViewController {

    var student: Student?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Student Details"
        view.backgroundColor = .systemBackground

        guard let student = student else {
            showMissingDataMessage()
            return
        }

        let nameLabel = UILabel()
        nameLabel.text = student.name
        nameLabel.font = .preferredFont(forTextStyle: .title1)
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontForContentSizeCategory = true

        let courseLabel = UILabel()
        courseLabel.text = "Course: \(student.course)"
        courseLabel.font = .preferredFont(forTextStyle: .body)
        courseLabel.adjustsFontForContentSizeCategory = true

        let marksLabel = UILabel()
        marksLabel.text = "Marks: \(student.marks)"
        marksLabel.font = .preferredFont(forTextStyle: .body)
        marksLabel.adjustsFontForContentSizeCategory = true

        let stack = UIStackView(arrangedSubviews: [nameLabel, courseLabel, marksLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func showMissingDataMessage() {
        let label = UILabel()
        label.text = "Student data is missing"
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
