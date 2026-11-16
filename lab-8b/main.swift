

import SwiftUI

struct Course: Identifiable, Hashable {
    let id: Int
    let title: String
    let category: String
    let duration: String
    let description: String
}

@main
struct Lab8BApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    @State private var searchText = ""
    @State private var showPopular = false

    let courses = [
        Course(id: 1, title: "Swift Basics", category: "Beginner", duration: "2 Weeks", description: "Learn Swift programming basics."),
        Course(id: 2, title: "SwiftUI", category: "iOS", duration: "3 Weeks", description: "Learn to create iOS applications."),
        Course(id: 3, title: "UIKit", category: "iOS", duration: "4 Weeks", description: "Learn UIKit components."),
        Course(id: 4, title: "Networking", category: "Advanced", duration: "2 Weeks", description: "Learn API and JSON parsing.")
    ]

    var filteredCourses: [Course] {

        var result = courses

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }

        if showPopular {
            result = result.filter {
                $0.category == "iOS"
            }
        }

        return result
    }

    var body: some View {

        NavigationStack {

            List(filteredCourses) { course in

                NavigationLink(value: course) {

                    VStack(alignment: .leading, spacing: 8) {

                        Text(course.title)
                            .font(.headline)

                        Text(course.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Course List")
            .navigationDestination(for: Course.self) { course in
                CourseDetailView(course: course)
            }
            .searchable(text: $searchText, prompt: "Search courses")
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        showPopular.toggle()
                    } label: {
                        Image(systemName: showPopular ? "star.fill" : "star")
                    }
                }
            }
        }
    }
}

struct CourseDetailView: View {

    let course: Course

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

            Spacer()
        }
        .padding()
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
