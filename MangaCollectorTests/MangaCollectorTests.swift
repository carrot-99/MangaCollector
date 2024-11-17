//  MangaCollectorTests.swift

import Testing
import CoreData
@testable import MangaCollector

struct MangaCollectorTests {
    private var context: NSManagedObjectContext

    @Test func testFetchMangas() async throws {
        var manga1 = Manga(context: context)
        var manga2 = Manga(context: context)
        var manga3 = Manga(context: context)
        var manga4 = Manga(context: context)
        var manga5 = Manga(context: context)
        manga1.order = 1
        manga2.order = 2
        manga3.order = 3
        manga4.order = 4
        manga5.order = 5
        var mangas = [
            manga1,
            manga2,
            manga3,
            manga4,
            manga5
        ]
        
        
        
    }

}
