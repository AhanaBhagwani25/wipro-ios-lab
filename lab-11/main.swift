
import SwiftUI

struct Course: Identifiable {
    let id: Int
    let title: String
    let description: String
}

@main
struct Lab11App: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    let courses = (1...500).map { number in
        Course(
            id: number,
            title: "Course \(number)",
            description: "Learn programming and app development."
        )
    }

    var body: some View {

        NavigationStack {

            List(courses) { course in

                VStack(alignment: .leading, spacing: 8) {

                    Text(course.title)
                        .font(.headline)

                    Text(course.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Course List")
        }
    }
}
