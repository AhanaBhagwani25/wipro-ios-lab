
import SwiftUI

struct Course: Identifiable {
    let id: Int
    let title: String
    let category: String
}

class CourseStore: ObservableObject {

    @Published var favorites: Set<Int> = []

    let courses = [
        Course(id: 1, title: "Swift Basics", category: "Beginner"),
        Course(id: 2, title: "SwiftUI", category: "iOS"),
        Course(id: 3, title: "UIKit", category: "iOS"),
        Course(id: 4, title: "Networking", category: "Advanced")
    ]

    init() {
        let savedFavorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        favorites = Set(savedFavorites)
    }

    func toggleFavorite(course: Course) {

        if favorites.contains(course.id) {
            favorites.remove(course.id)
        } else {
            favorites.insert(course.id)
        }

        UserDefaults.standard.set(Array(favorites), forKey: "favorites")
    }
}

@main
struct Lab8CApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    @StateObject var store = CourseStore()

    var body: some View {

        NavigationStack {
            CourseListView()
                .environmentObject(store)
        }
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

        List(filteredCourses) { course in

            NavigationLink(destination: CourseDetailView(course: course)) {

                HStack {

                    VStack(alignment: .leading, spacing: 5) {

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
        .navigationTitle("Courses")
        .searchable(text: $searchText)
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button {
                    showFavorites.toggle()
                } label: {
                    Image(systemName: showFavorites ? "heart.fill" : "heart")
                }
            }
        }
        .overlay {

            if filteredCourses.isEmpty {
                ContentUnavailableView(
                    "No Courses Found",
                    systemImage: "book.closed"
                )
            }
        }
    }
}

struct CourseDetailView: View {

    @EnvironmentObject var store: CourseStore

    let course: Course

    var body: some View {

        VStack(spacing: 20) {

            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text(course.title)
                .font(.largeTitle)
                .bold()

            Text("Category: \(course.category)")
                .font(.headline)

            FavoriteButton(
                isFavorite: Binding(
                    get: {
                        store.favorites.contains(course.id)
                    },
                    set: { _ in
                        store.toggleFavorite(course: course)
                    }
                )
            )

            Spacer()
        }
        .padding()
        .navigationTitle("Course Details")
    }
}

struct FavoriteButton: View {

    @Binding var isFavorite: Bool

    var body: some View {

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
    }
}

