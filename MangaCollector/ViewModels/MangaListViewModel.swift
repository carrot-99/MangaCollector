//  MangaListViewModel.swift

import Foundation
import CoreData

final class MangaListViewModel: ObservableObject {
    /// order 順の全作品
    @Published private(set) var mangas: [Manga] = []
    @Published var sortOption: SortOption {
        didSet { UserDefaults.standard.set(sortOption.rawValue, forKey: UserDefaultsKey.sortOption) }
    }
    @Published var filterOption: FilterOption = .all
    @Published var searchText = ""

    private let service: MangaService

    init(context: NSManagedObjectContext) {
        self.service = MangaService(context: context)
        let savedSort = UserDefaults.standard.string(forKey: UserDefaultsKey.sortOption)
        self.sortOption = savedSort.flatMap(SortOption.init(rawValue:)) ?? .defaultOrder
        fetchMangas()
    }

    // MARK: - 表示用

    /// 検索・フィルタ・並び替えを適用した作品一覧
    var displayedMangas: [Manga] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = mangas.filter { manga in
            guard filterOption.matches(manga) else { return false }
            guard !query.isEmpty else { return true }
            return manga.displayTitle.localizedCaseInsensitiveContains(query)
                || manga.authorsArray.contains { $0.localizedCaseInsensitiveContains(query) }
        }
        return sorted(filtered)
    }

    /// 手動並べ替えが可能な状態か
    var canReorder: Bool {
        sortOption == .defaultOrder && filterOption == .all && searchText.isEmpty
    }

    var isFiltering: Bool {
        filterOption != .all || !searchText.isEmpty
    }

    private func sorted(_ list: [Manga]) -> [Manga] {
        switch sortOption {
        case .defaultOrder:
            return list
        case .titleAscending:
            return list.sorted { $0.displayTitle.localizedStandardCompare($1.displayTitle) == .orderedAscending }
        case .titleDescending:
            return list.sorted { $0.displayTitle.localizedStandardCompare($1.displayTitle) == .orderedDescending }
        case .volumeAscending:
            return list.sorted { $0.totalOwnedVolumes < $1.totalOwnedVolumes }
        case .volumeDescending:
            return list.sorted { $0.totalOwnedVolumes > $1.totalOwnedVolumes }
        }
    }

    // MARK: - Manga

    func fetchMangas() {
        mangas = service.fetchMangas()
    }

    func addManga(title: String, publicationStatus: PublicationStatus, ownedVolumes: Int16, image: Data?) {
        service.addManga(title: title, publicationStatus: publicationStatus, ownedVolumes: ownedVolumes, image: image)
        fetchMangas()
    }

    func updateManga(_ manga: Manga, with draft: MangaDraft) -> Bool {
        let result = service.updateManga(manga, with: draft)
        fetchMangas()
        return result
    }

    func incrementOwnedVolumes(of manga: Manga) {
        service.incrementOwnedVolumes(of: manga)
        fetchMangas()
    }

    func deleteMangas(_ targets: [Manga]) {
        targets.forEach(service.deleteManga)
        fetchMangas()
    }

    func moveMangas(from source: IndexSet, to destination: Int) {
        var reordered = mangas
        reordered.move(fromOffsets: source, toOffset: destination)
        service.reorder(reordered)
        fetchMangas()
    }

    // MARK: - OtherTitle

    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        service.addOtherTitle(to: manga, title: title, ownedVolumes: ownedVolumes, notes: notes)
        fetchMangas()
    }

    func updateOtherTitle(_ otherTitle: OtherTitle, title: String, ownedVolumes: Int16, notes: String) {
        service.updateOtherTitle(otherTitle, title: title, ownedVolumes: ownedVolumes, notes: notes)
        fetchMangas()
    }

    func deleteOtherTitle(_ otherTitle: OtherTitle) {
        service.deleteOtherTitle(otherTitle)
        fetchMangas()
    }

    // MARK: - Graph

    func countTitlesByStatus() -> [PublicationStatus: Int] {
        GraphViewModel.countTitlesByStatus(mangas: mangas)
    }

    func countVolumesByStatus() -> [PublicationStatus: Int] {
        GraphViewModel.countVolumesByStatus(mangas: mangas)
    }
}
