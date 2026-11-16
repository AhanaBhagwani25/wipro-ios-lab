
import SwiftUI

@main
struct Lab10BApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var showSuccess = false
    @State private var showError = false

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        email.contains(".")
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Student Details") {

                    TextField("Enter Name", text: $name)
                        .accessibilityIdentifier("nameField")

                    TextField("Enter Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .accessibilityIdentifier("emailField")
                }

                Section {

                    Button("Submit") {

                        if isValid {
                            showSuccess = true
                        } else {
                            showError = true
                        }
                    }
                    .accessibilityIdentifier("submitButton")
                }
            }
            .navigationTitle("Student Form")
            .alert("Registration Successful", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Student details submitted successfully.")
            }
            .alert("Validation Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter valid name and email.")
            }
        }
    }
}
