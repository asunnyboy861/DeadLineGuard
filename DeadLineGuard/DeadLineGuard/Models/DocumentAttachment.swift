import Foundation
import SwiftData

@Model
final class DocumentAttachment {
    var id: UUID = UUID()
    var name: String = ""
    var fileType: String = ""
    var imageData: Data?
    var attachedDate: Date = Date()
    var item: ComplianceItem?

    init(name: String, fileType: String, imageData: Data?) {
        self.id = UUID()
        self.name = name
        self.fileType = fileType
        self.imageData = imageData
        self.attachedDate = Date()
    }
}
