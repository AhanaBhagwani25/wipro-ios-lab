
import SwiftUI

struct Course: Identifiable {
    let id: Int
    let title: String
    let category: String
    let duration: String
    let description: String
}

struct Lab8AApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    let courses = [
        Course(id: 1, title: "Swift Basics", category: "Beginner", duration: "2 Weeks", description: "Learn variables, constants, loops and functions in Swift."),
        Course(id: 2, title: "SwiftUI", category: "iOS", duration: "3 Weeks", description: "Learn how to create user interfaces using SwiftUI."),
        Course(id: 3, title: "UIKit", category: "iOS", duration: "4 Weeks", description: "Learn buttons, labels, text fields and view controllers."),
        Course(id: 4, title: "Networking", category: "Advanced", duration: "2 Weeks", description: "Learn API calls and JSON parsing.")
    ]

    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 15) {

                Text("Course Explorer")
                    .font(.largeTitle)
                    .bold()

                Text("Explore our courses")
                    .font(.title3)
                    .foregroundColor(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {

                    HStack(spacing: 10) {

                        CategoryView(title: "All")
                        CategoryView(title: "Beginner")
                        CategoryView(title: "iOS")
                        CategoryView(title: "Advanced")
                    }
                }

                if courses.isEmpty {

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 100, height: 100)

                        Image(systemName: "book.closed")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)

                    Text("No courses available")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)

                    Spacer()

                } else {

                    List(courses) { course in

                        NavigationLink(destination: CourseDetailView(course: course)) {

                            CourseCardView(course: course)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CategoryView: View {

    let title: String

    var body: some View {

        Text(title)
            .font(.subheadline)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(20)
    }
}

struct CourseCardView: View {

    let course: Course

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Text(course.title)
                    .font(.headline)

                Spacer()

                Image(systemName: "book.fill")
                    .foregroundColor(.blue)
            }

            Text(course.category)
                .font(.caption)
                .foregroundColor(.blue)

            Text(course.duration)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct CourseDetailView: View {

    let course: Course

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            Image(systemName: "book.fill")
                .font(.system(size: 70))
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
    }
}

struct CourseCardView_Previews: PreviewProvider {

    static var previews: some View {

        CourseCardView(
            course: Course(
                id: 1,
                title: "Swift Basics",
                category: "Beginner",
                duration: "2 Weeks",
                description: "Learn Swift basics."
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
