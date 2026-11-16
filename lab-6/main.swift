import Foundation

struct Address: Codable, Equatable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct Company: Codable, Equatable {
    let name: String
}

struct User: Codable, Equatable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: Address
    let company: Company
}

enum ApiError: Error, Equatable {
    case invalidURL
    case badStatus(Int)
    case decodingFailed
    case noInternet
    case unknown

    var message: String {
        switch self {
        case .invalidURL:
            return "The web address is not valid."
        case .badStatus(let code):
            if code == 404 {
                return "Data not found (error 404)."
            }
            if code >= 500 {
                return "Server problem (error \(code)). Please try again later."
            }
            return "Request failed with status \(code)."
        case .decodingFailed:
            return "Could not read the data from the server."
        case .noInternet:
            return "No internet connection. Check your network and retry."
        case .unknown:
            return "Something went wrong."
        }
    }
}

protocol UserFetching {
    func fetchUsers() async throws -> [User]
}

struct UserService: UserFetching {

    let host: String
    let path: String
    let session: URLSession

    init(host: String = "jsonplaceholder.typicode.com", path: String = "/users", session: URLSession = .shared) {
        self.host = host
        self.path = path
        self.session = session
    }

    func makeRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path

        guard let url = components.url else {
            throw ApiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    func validate(statusCode: Int) throws {
        if !(200...299).contains(statusCode) {
            throw ApiError.badStatus(statusCode)
        }
    }

    func decodeUsers(from data: Data) throws -> [User] {
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw ApiError.decodingFailed
        }
    }

    func fetchUsers() async throws -> [User] {
        let request = try makeRequest()

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.unknown
            }

            try validate(statusCode: httpResponse.statusCode)
            return try decodeUsers(from: data)

        } catch let error as ApiError {
            throw error
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotFindHost, .cannotConnectToHost:
                throw ApiError.noInternet
            default:
                throw ApiError.unknown
            }
        } catch {
            throw ApiError.unknown
        }
    }
}
import UIKit

enum ScreenState {
    case loading
    case loaded([User])
    case empty
    case failed(String)
}

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    let service: any UserFetching
    let tableView = UITableView()
    let spinner = UIActivityIndicatorView(style: .large)
    let messageLabel = UILabel()
    let retryButton = UIButton(type: .system)
    let searchController = UISearchController(searchResultsController: nil)

    var allUsers: [User] = []
    var shownUsers: [User] = []

    init(service: any UserFetching = UserService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Directory"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.adjustsFontForContentSizeCategory = true

        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        let stateStack = UIStackView(arrangedSubviews: [spinner, messageLabel, retryButton])
        stateStack.axis = .vertical
        stateStack.spacing = 16
        stateStack.alignment = .center
        stateStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stateStack)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name"
        navigationItem.searchController = searchController

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stateStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stateStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])

        loadUsers()
    }

    @objc func retryTapped() {
        loadUsers()
    }

    func loadUsers() {
        showState(.loading)

        Task {
            do {
                let users = try await service.fetchUsers()
                if users.isEmpty {
                    showState(.empty)
                } else {
                    allUsers = users
                    shownUsers = users
                    showState(.loaded(users))
                }
            } catch let error as ApiError {
                showState(.failed(error.message))
            } catch {
                showState(.failed("Something went wrong."))
            }
        }
    }

    func showState(_ state: ScreenState) {
        switch state {
        case .loading:
            spinner.startAnimating()
            messageLabel.isHidden = true
            retryButton.isHidden = true
            tableView.isHidden = true

        case .loaded:
            spinner.stopAnimating()
            messageLabel.isHidden = true
            retryButton.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()

        case .empty:
            spinner.stopAnimating()
            messageLabel.text = "No users found."
            messageLabel.isHidden = false
            retryButton.setTitle("Reload", for: .normal)
            retryButton.isHidden = false
            tableView.isHidden = true

        case .failed(let message):
            spinner.stopAnimating()
            messageLabel.text = message
            messageLabel.isHidden = false
            retryButton.setTitle("Retry", for: .normal)
            retryButton.isHidden = false
            tableView.isHidden = true
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        if text.isEmpty {
            shownUsers = allUsers
        } else {
            shownUsers = allUsers.filter { $0.name.localizedCaseInsensitiveContains(text) }
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "UserCell")
        let user = shownUsers[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailScreen = UserDetailViewController(user: shownUsers[indexPath.row])
        navigationController?.pushViewController(detailScreen, animated: true)
    }
}

class UserDetailViewController: UIViewController {

    let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemBackground

        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.font = .preferredFont(forTextStyle: .title1)
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontForContentSizeCategory = true

        let addressText = "\(user.address.street), \(user.address.suite), \(user.address.city) - \(user.address.zipcode)"
        let rows = [
            ("Username", user.username),
            ("Email", user.email),
            ("Phone", user.phone),
            ("Website", user.website),
            ("Address", addressText),
            ("Company", user.company.name)
        ]

        var labels: [UIView] = [nameLabel]
        for row in rows {
            let label = UILabel()
            label.text = "\(row.0): \(row.1)"
            label.numberOfLines = 0
            label.font = .preferredFont(forTextStyle: .body)
            label.adjustsFontForContentSizeCategory = true
            labels.append(label)
        }

        let stack = UIStackView(arrangedSubviews: labels)
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
}
