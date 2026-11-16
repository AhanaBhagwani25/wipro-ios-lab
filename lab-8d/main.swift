
import SwiftUI

@main
struct Lab8DApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var selectedEvent = "iOS Workshop"
    @State private var receiveUpdates = false
    @State private var message = ""

    @State private var showSuccess = false

    let events = [
        "iOS Workshop",
        "SwiftUI Seminar",
        "App Development",
        "Coding Competition"
    ]

    var isValid: Bool {

        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        email.contains(".")
    }

    var body: some View {

        NavigationStack {

            Form {

                Section(header: Text("Personal Details")) {

                    TextField("Enter your name", text: $name)

                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section(header: Text("Event Details")) {

                    Picker("Select Event", selection: $selectedEvent) {

                        ForEach(events, id: \.self) { event in
                            Text(event)
                        }
                    }

                    Toggle("Receive Updates", isOn: $receiveUpdates)
                }

                Section(header: Text("Additional Information")) {

                    TextEditor(text: $message)
                        .frame(minHeight: 120)
                }

                Section {

                    if name.isEmpty || email.isEmpty {

                        Text("Please fill all required fields.")
                            .foregroundColor(.red)
                            .font(.caption)

                    } else if !isValid {

                        Text("Please enter a valid email address.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button("Submit Registration") {

                        if isValid {
                            showSuccess = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!isValid)
                }
            }
            .navigationTitle("Event Registration")
            .alert("Registration Successful", isPresented: $showSuccess) {

                Button("OK", role: .cancel) {
                    name = ""
                    email = ""
                    message = ""
                    selectedEvent = "iOS Workshop"
                    receiveUpdates = false
                }

            } message: {

                Text("Your registration has been submitted successfully.")
            }
        }
    }
}

