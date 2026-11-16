
import SwiftUI

struct Course: Identifiable {
    let id: Int
    let title: String
    let category: String
    let duration: String
    let description: String
}

class CourseStore: ObservableObject {

    @Published var favorites: Set<Int> = []

    let courses = [
        Course(id: 1, title: "Swift Basics", category: "Beginner", duration: "2 Weeks", description: "Learn variables, constants, loops and functions in Swift."),
        Course(id: 2, title: "SwiftUI", category: "iOS", duration: "3 Weeks", description: "Learn how to create iOS applications using SwiftUI."),
        Course(id: 3, title: "UIKit", category: "iOS", duration: "4 Weeks", description: "Learn buttons, labels, text fields and view controllers."),
        Course(id: 4, title: "Networking", category: "Advanced", duration: "2 Weeks", description: "Learn API requests and JSON parsing.")
    ]

    func toggleFavorite(course: Course) {

        if favorites.contains(course.id) {
            favorites.remove(course.id)
        } else {
            favorites.insert(course.id)
        }
    }
}

@main
struct AssessmentMilestone4App: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    @StateObject var store = CourseStore()

    var body: some View {

        TabView {

            NavigationStack {
                CourseListView()
            }
            .tabItem {
                Label("Courses", systemImage: "book.fill")
            }

            NavigationStack {
                RegistrationView()
            }
            .tabItem {
                Label("Register", systemImage: "person.fill")
            }
        }
        .environmentObject(store)
    }
}

struct CourseListView: View {

    @EnvironmentObject var store: CourseStore

    @State private var searchText = ""
    @State private var showFavorites = false

    var filteredCourses: [Course] {

        var result = store.courses

        if showFavorites {
            result = result.filter {
                store.favorites.contains($0.id)
            }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }

        return result
    }

    var body: some View {

        VStack {

            if filteredCourses.isEmpty {

                Spacer()

                Image(systemName: "book.closed")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)

                Text("No Courses Found")
                    .font(.headline)

                Spacer()

            } else {

                List(filteredCourses) { course in

                    NavigationLink(destination: CourseDetailView(
                        course: course,
                        isFavorite: Binding(
                            get: {
                                store.favorites.contains(course.id)
                            },
                            set: { value in
                                if value {
                                    store.favorites.insert(course.id)
                                } else {
                                    store.favorites.remove(course.id)
                                }
                            }
                        )
                    )) {

                        HStack {

                            VStack(alignment: .leading, spacing: 6) {

                                Text(course.title)
                                    .font(.headline)

                                Text(course.category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if store.favorites.contains(course.id) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Course Explorer")
        .searchable(text: $searchText, prompt: "Search courses")
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button {
                    showFavorites.toggle()
                } label: {
                    Image(systemName: showFavorites ? "heart.fill" : "heart")
                }
            }
        }
    }
}

struct CourseDetailView: View {

    let course: Course

    @Binding var isFavorite: Bool

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            Image(systemName: "book.fill")
                .font(.system(size: 65))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)

            Text(course.title)
                .font(.largeTitle)
                .bold()

            Text("Category: \(course.category)")
                .font(.headline)

            Text("Duration: \(course.duration)")
                .font(.headline)

            Text(course.description)
                .font(.body)

            Button {

                isFavorite.toggle()

            } label: {

                Label(
                    isFavorite ? "Remove Favourite" : "Add Favourite",
                    systemImage: isFavorite ? "heart.fill" : "heart"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RegistrationView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var selectedEvent = "iOS Workshop"
    @State private var receiveUpdates = false
    @State private var message = ""

    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var showError = false

    let events = [
        "iOS Workshop",
        "SwiftUI Seminar",
        "App Development",
        "Coding Competition"
    ]

    var isFormValid: Bool {

        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        email.contains(".")
    }

    var body: some View {

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
                    .frame(minHeight: 100)
            }

            Section {

                if !isFormValid {

                    Text("Please enter your name and a valid email.")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                Button {

                    submitForm()

                } label: {

                    if isLoading {

                        ProgressView()
                            .frame(maxWidth: .infinity)

                    } else {

                        Text("Submit Registration")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(isLoading)
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

            Text("Your registration has been completed successfully.")
        }
        .alert("Invalid Details", isPresented: $showError) {

            Button("OK", role: .cancel) { }

        } message: {

            Text("Please enter your name and a valid email address.")
        }
    }

    func submitForm() {

        if !isFormValid {
            showError = true
            return
        }

        isLoading = true

        Task {

            try? await Task.sleep(nanoseconds: 1500000000)

            isLoading = false
            showSuccess = true
        }
    }
}
