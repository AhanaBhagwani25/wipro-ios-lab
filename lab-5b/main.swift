import SwiftUI

enum FetchMode {
    case normal
    case empty
    case fail
}

enum CourseError: Error {
    case networkFailed
}

enum LoadState {
    case idle
    case loading
    case success([String])
    case empty
    case failure(String)
    case cancelled
}

func fetchCourses(mode: FetchMode) async throws -> [String] {
    try await Task.sleep(nanoseconds: 3_000_000_000)

    switch mode {
    case .normal:
        return ["Swift Basics", "iOS Development", "Data Structures", "Databases"]
    case .empty:
        return []
    case .fail:
        throw CourseError.networkFailed
    }
}

@MainActor
class CourseViewModel: ObservableObject {

    @Published var state: LoadState = .idle
    private var loadTask: Task<Void, Never>?

    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    func load(mode: FetchMode) {
        if isLoading { return }
        state = .loading

        loadTask = Task {
            do {
                let courses = try await fetchCourses(mode: mode)
                if courses.isEmpty {
                    state = .empty
                } else {
                    state = .success(courses)
                }
            } catch is CancellationError {
                state = .cancelled
            } catch {
                state = .failure("Could not load courses. Please try again.")
            }
        }
    }

    func cancel() {
        loadTask?.cancel()
    }

    func retry() {
        load(mode: .normal)
    }
}

struct CourseListView: View {

    @StateObject private var viewModel = CourseViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Courses")
                .font(.largeTitle)

            HStack(spacing: 20) {
                Button("Load") { viewModel.load(mode: .normal) }
                Button("Empty") { viewModel.load(mode: .empty) }
                Button("Fail") { viewModel.load(mode: .fail) }
            }
            .disabled(viewModel.isLoading)

            Button("Cancel") {
                viewModel.cancel()
            }
            .disabled(!viewModel.isLoading)

            content

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle:
            Text("Press a button to load courses")
        case .loading:
            ProgressView("Loading...")
        case .success(let courses):
            List(courses, id: \.self) { course in
                Text(course)
            }
        case .empty:
            Text("No courses found")
        case .failure(let message):
            VStack(spacing: 10) {
                Text(message)
                    .foregroundColor(.red)
                Button("Retry") {
                    viewModel.retry()
                }
            }
        case .cancelled:
            Text("Loading was cancelled")
        }
    }
}

#Preview {
    CourseListView()
}
