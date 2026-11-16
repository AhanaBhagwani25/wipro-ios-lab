import SwiftUI
import UIKit

struct GreetingView: View {

    @State private var name = ""
    @State private var result = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Greeting App")
                .font(.largeTitle)

            TextField("Enter your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Say Hello") {
                if name.isEmpty {
                    result = "Please enter your name"
                } else {
                    result = "Hello, \(name)!"
                }
            }

            Text(result)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

#Preview {
    GreetingView()
}

class GreetingViewController: UIViewController {

    let titleLabel = UILabel()
    let nameField = UITextField()
    let helloButton = UIButton(type: .system)
    let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        titleLabel.text = "Greeting App"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)

        nameField.placeholder = "Enter your name"
        nameField.borderStyle = .roundedRect

        helloButton.setTitle("Say Hello", for: .normal)

        helloButton.addTarget(self, action: #selector(helloTapped), for: .touchUpInside)

        resultLabel.textColor = .systemBlue

        let stack = UIStackView(arrangedSubviews: [titleLabel, nameField, helloButton, resultLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func helloTapped() {
        let name = nameField.text ?? ""
        if name.isEmpty {
            resultLabel.text = "Please enter your name"
        } else {
            resultLabel.text = "Hello, \(name)!"
        }
    }
}
