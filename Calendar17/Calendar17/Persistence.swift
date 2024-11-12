import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Calendar17")
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        if inMemory {
            description?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        deletePersistentStore()
        
        // 永続ストアのロード
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Persistent store failed to load: \(error)")
            }
        }
    }


    func deletePersistentStore() {
        // 永続ストアのファイルの場所を取得する
        guard let persistentStore = container.persistentStoreCoordinator.persistentStores.first else {
            print("永続ストアが見つかりません")
            return
        }

        do {
            // 永続ストアを削除する（マイグレーションを無視して行う）
            try container.persistentStoreCoordinator.remove(persistentStore)
            // ストアファイルを物理的に削除する
            if let storeURL = persistentStore.url {
                try FileManager.default.removeItem(at: storeURL)
                print("永続ストアが削除されました")
            }
        } catch {
            print("永続ストアを削除できませんでした: \(error)")
        }
    }
}
