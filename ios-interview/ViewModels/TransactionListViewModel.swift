//
//  TransactionListViewModel.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

struct TransactionDateSection: Identifiable {
    let date: Date
    let activityItems: [ActivityItem]

    var id: Date { date }
}

@MainActor
@Observable
final class TransactionListViewModel {
    
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    var activityItems: [ActivityItem] = []
    var activitySections: [TransactionDateSection] = []
    var nextCursor: String?
    var hasMore = true
    var isLoading = false

    func update() async {
        guard !isLoading, hasMore else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        var queryItems: [URLQueryItem] = []
        if let nextCursor {
            queryItems = [.init(name: "cursor", value: nextCursor)]
        }
        let url = API.baseURL.appendingPathComponent("api/merchant/activity")
            .appending(queryItems: queryItems)

        do {
            let (data, response) = try await API.session.data(from: url)
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                return
            }

            let paginatedActivity = try JSONDecoder().decode(PaginatedActivityResponse.self, from: data)
            activityItems += paginatedActivity.items
            nextCursor = paginatedActivity.next_cursor
            hasMore = paginatedActivity.has_more
            activitySections = makeActivitySections(from: activityItems)
        } catch {
            print(error)
        }
    }
    
    private func makeActivitySections(from activityItems: [ActivityItem]) -> [TransactionDateSection] {
        let calendar = Calendar.current

        return activityItems.reduce(into: []) { sections, item in
            guard let date = Self.dateFormatter.date(from: item.date) else {
                return
            }

            let day = calendar.startOfDay(for: date)
            if let lastSection = sections.last, calendar.isDate(lastSection.date, inSameDayAs: day) {
                sections[sections.count - 1] = TransactionDateSection(
                    date: lastSection.date,
                    activityItems: lastSection.activityItems + [item]
                )
            } else {
                sections.append(TransactionDateSection(date: day, activityItems: [item]))
            }
        }
    }
}
