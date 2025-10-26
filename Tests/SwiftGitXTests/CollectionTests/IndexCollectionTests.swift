@testable import SwiftGitX
import XCTest

final class IndexCollectionTests: SwiftGitXTestCase {
    func testIndexAddPath() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-add-path", in: Self.directory)

        // Create a file in the repository
        _ = try repository.mockFile(named: "README.md", content: "Hello, World!")

        // Stage the file using the file path
        XCTAssertNoThrow(try repository.add(path: "README.md"))

        // Verify that the file is staged
        let statusEntry = try XCTUnwrap(repository.status().first)

        XCTAssertEqual(statusEntry.status, [.indexNew]) // The file is staged
        XCTAssertEqual(statusEntry.index?.newFile.path, "README.md")
        XCTAssertNil(statusEntry.workingTree) // The file is staged and not in the working tree anymore
    }

    func testIndexAddFile() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-add-file", in: Self.directory)

        // Create a file in the repository
        let file = try repository.mockFile(named: "README.md", content: "Hello, World!")

        // Stage the file using the file URL
        XCTAssertNoThrow(try repository.add(file: file))

        // Verify that the file is staged
        let statusEntry = try XCTUnwrap(repository.status().first)

        XCTAssertEqual(statusEntry.status, [.indexNew]) // The file is staged
        XCTAssertEqual(statusEntry.index?.newFile.path, "README.md")
        XCTAssertNil(statusEntry.workingTree) // The file is staged and not in the working tree anymore
    }

    func testIndexAddPaths() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-add-paths", in: Self.directory)

        // Create new files in the repository
        let files = try (0 ..< 10).map { index in
            try repository.mockFile(named: "README-\(index).md", content: "Hello, World!")
        }

        // Stage the files using the file paths
        XCTAssertNoThrow(try repository.add(paths: files.map(\.lastPathComponent)))

        // Verify that the files are staged
        let statusEntries = try repository.status()

        XCTAssertEqual(statusEntries.count, files.count)
        XCTAssertEqual(statusEntries.map(\.status), Array(repeating: [.indexNew], count: files.count))
        XCTAssertEqual(statusEntries.map(\.index?.newFile.path), files.map(\.lastPathComponent))
        XCTAssertEqual(statusEntries.map(\.workingTree), Array(repeating: nil, count: files.count))
    }

    func testIndexAddFiles() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-add-files", in: Self.directory)

        // Create new files in the repository
        let files = try (0 ..< 10).map { index in
            try repository.mockFile(named: "README-\(index).md", content: "Hello, World!")
        }

        // Stage the files using the file URLs
        XCTAssertNoThrow(try repository.add(files: files))

        // Verify that the files are staged
        let statusEntries = try repository.status()

        XCTAssertEqual(statusEntries.count, files.count)
        XCTAssertEqual(statusEntries.map(\.status), Array(repeating: [.indexNew], count: files.count))
        XCTAssertEqual(statusEntries.map(\.index?.newFile.path), files.map(\.lastPathComponent))
        XCTAssertEqual(statusEntries.map(\.workingTree), Array(repeating: nil, count: files.count))
    }

    // TODO: Add test for add all

    func testIndexRemovePath() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-remove-path", in: Self.directory)

        // Create a file in the repository
        let file = try repository.mockFile(named: "README.md", content: "Hello, World!")

        // Stage the file
        XCTAssertNoThrow(try repository.add(file: file))

        // Unstage the file using the file path
        XCTAssertNoThrow(try repository.remove(path: "README.md"))

        // Verify that the file is not staged
        let statusEntry = try XCTUnwrap(repository.status().first)

        XCTAssertEqual(statusEntry.status, [.workingTreeNew])
        XCTAssertNil(statusEntry.index) // The file is not staged
    }

    func testIndexRemoveFile() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-remove-file", in: Self.directory)

        // Create a file in the repository
        let file = try repository.mockFile(named: "README.md", content: "Hello, World!")

        // Stage the file
        XCTAssertNoThrow(try repository.add(file: file))

        // Unstage the file using the file URL
        XCTAssertNoThrow(try repository.remove(file: file))

        // Verify that the file is not staged
        let statusEntry = try XCTUnwrap(repository.status().first)

        XCTAssertEqual(statusEntry.status, [.workingTreeNew])
        XCTAssertNil(statusEntry.index) // The file is not staged
    }

    func testIndexRemovePaths() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-remove-paths", in: Self.directory)

        // Create new files in the repository
        let files = try (0 ..< 10).map { index in
            try repository.mockFile(named: "README-\(index).md", content: "Hello, World!")
        }

        // Stage the files
        XCTAssertNoThrow(try repository.add(files: files))

        // Unstage the files using the file paths
        XCTAssertNoThrow(try repository.remove(paths: files.map(\.lastPathComponent)))

        // Verify that the files are not staged
        let statusEntries = try repository.status()

        XCTAssertEqual(statusEntries.count, files.count)
        XCTAssertEqual(statusEntries.map(\.status), Array(repeating: [.workingTreeNew], count: files.count))
        XCTAssertEqual(statusEntries.map(\.index), Array(repeating: nil, count: files.count))
    }

    func testIndexRemoveFiles() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-remove-files", in: Self.directory)

        // Create new files in the repository
        let files = try (0 ..< 10).map { index in
            try repository.mockFile(named: "README-\(index).md", content: "Hello, World!")
        }

        // Stage the files
        XCTAssertNoThrow(try repository.add(files: files))

        // Unstage the files using the file URLs
        XCTAssertNoThrow(try repository.remove(files: files))

        // Verify that the files are not staged
        let statusEntries = try repository.status()

        XCTAssertEqual(statusEntries.count, files.count)
        XCTAssertEqual(statusEntries.map(\.status), Array(repeating: [.workingTreeNew], count: files.count))
        XCTAssertEqual(statusEntries.map(\.index), Array(repeating: nil, count: files.count))
    }

    func testIndexRemoveAll() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-remove-all", in: Self.directory)

        // Create new files in the repository
        let files = try (0 ..< 10).map { index in
            try repository.mockFile(named: "README-\(index).md", content: "Hello, World!")
        }

        // Stage the files
        XCTAssertNoThrow(try repository.add(files: files))

        // Unstage all files
        XCTAssertNoThrow(try repository.index.removeAll())
    }

    func testIndexAddDeletedFile() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-add-deleted-file", in: Self.directory)

        // Create a file and commit it
        let file = try repository.mockFile(named: "ToDelete.md", content: "This file will be deleted")
        try repository.mockCommit(message: "Initial commit", file: file)

        // Verify file exists and status is clean
        XCTAssertTrue(FileManager.default.fileExists(atPath: file.path))
        XCTAssertTrue(try repository.status().isEmpty)

        // Delete the file from the working directory
        try FileManager.default.removeItem(at: file)

        // Verify the file is deleted and shows as workingTreeDeleted
        let statusBeforeStaging = try repository.status()
        XCTAssertEqual(statusBeforeStaging.count, 1)
        XCTAssertEqual(statusBeforeStaging.first?.status, [.workingTreeDeleted])

        // Stage the deletion using add(paths:)
        XCTAssertNoThrow(try repository.add(paths: ["ToDelete.md"]))

        // Verify the deletion is now staged
        let statusAfterStaging = try repository.status()
        XCTAssertEqual(statusAfterStaging.count, 1)
        XCTAssertEqual(statusAfterStaging.first?.status, [.indexDeleted])
        XCTAssertNotNil(statusAfterStaging.first?.index)
        XCTAssertNil(statusAfterStaging.first?.workingTree)
    }

    func testIndexAddMultipleFilesWithDeletion() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-add-multiple-with-deletion", in: Self.directory)

        // Create and commit some files
        let file1 = try repository.mockFile(named: "File1.md", content: "File 1")
        let file2 = try repository.mockFile(named: "File2.md", content: "File 2")
        let file3 = try repository.mockFile(named: "File3.md", content: "File 3")

        // Add and commit all files
        try repository.add(files: [file1, file2, file3])
        try repository.commit(message: "Initial commit")

        // Verify clean status
        XCTAssertTrue(try repository.status().isEmpty)

        // Modify file1, delete file2, and leave file3 unchanged
        try Data("Modified File 1".utf8).write(to: file1)
        try FileManager.default.removeItem(at: file2)

        // Create a new file
        _ = try repository.mockFile(named: "File4.md", content: "New File 4")

        // Stage all changes
        try repository.add(paths: ["File1.md", "File2.md", "File4.md"])

        // Verify all changes are staged
        let statusEntries = try repository.status()
        XCTAssertEqual(statusEntries.count, 3)

        // Find each file's status
        let file1Status = statusEntries.first { $0.index?.newFile.path == "File1.md" }
        let file2Status = statusEntries.first { $0.index?.oldFile.path == "File2.md" }
        let file4Status = statusEntries.first { $0.index?.newFile.path == "File4.md" }

        // File1 should be modified
        XCTAssertEqual(file1Status?.status, [.indexModified])

        // File2 should be deleted
        XCTAssertEqual(file2Status?.status, [.indexDeleted])

        // File4 should be new
        XCTAssertEqual(file4Status?.status, [.indexNew])
    }

    func testIndexAddRenamedFile() throws {
        // Create a repository
        let repository = Repository.mock(named: "test-index-add-renamed-file", in: Self.directory)

        // Create a file and commit it
        let oldFile = try repository.mockFile(named: "OldName.md", content: "This file will be renamed")
        try repository.mockCommit(message: "Initial commit", file: oldFile)

        // Verify file exists and status is clean
        XCTAssertTrue(FileManager.default.fileExists(atPath: oldFile.path))
        XCTAssertTrue(try repository.status().isEmpty)

        // Rename the file by moving it
        let newFile = try repository.workingDirectory.appendingPathComponent("NewName.md")
        try FileManager.default.moveItem(at: oldFile, to: newFile)
        _ = newFile // Suppress unused variable warning

        // Check status before staging (with rename detection for working tree)
        let statusBeforeStaging = try repository.status(options: [.includeUntracked, .renamesWorkingTree])
        print("Status before staging (with rename detection):")
        for entry in statusBeforeStaging {
            print("  Status: \(entry.status)")
            print("  Old path: \(entry.workingTree?.oldFile.path ?? entry.index?.oldFile.path ?? "nil")")
            print("  New path: \(entry.workingTree?.newFile.path ?? entry.index?.newFile.path ?? "nil")")
        }

        // Stage both paths together using add(paths:)
        // This uses both git_index_add_all (for new file) and git_index_update_all (for deleted file)
        try repository.add(paths: ["NewName.md", "OldName.md"])

        // Check final status WITHOUT rename detection
        let statusWithoutRenames = try repository.status()
        print("\nStatus after staging (without rename detection):")
        for entry in statusWithoutRenames {
            print("  Status: \(entry.status)")
            print("  Old path: \(entry.index?.oldFile.path ?? "nil")")
            print("  New path: \(entry.index?.newFile.path ?? "nil")")
        }

        // Check final status WITH rename detection for index
        let statusWithRenames = try repository.status(options: [.includeUntracked, .renamesIndex])
        print("\nStatus after staging (with rename detection for index):")
        for entry in statusWithRenames {
            print("  Status: \(entry.status)")
            print("  Old path: \(entry.index?.oldFile.path ?? "nil")")
            print("  New path: \(entry.index?.newFile.path ?? "nil")")
        }

        // Verify the rename is detected and staged when using rename detection
        XCTAssertEqual(statusWithRenames.count, 1, "Should have exactly one status entry for the rename")
        if let renamedEntry = statusWithRenames.first {
            XCTAssertTrue(
                renamedEntry.status.contains(.indexRenamed),
                "Status should contain indexRenamed, got: \(renamedEntry.status)"
            )
        }
    }
}
