//
//  CommentsUIIntegrationTests+Assertions.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-06-30.
//

import XCTest
import EssentialFeed
import EssentialFeediOS
import EssentialApp

extension CommentsUIIntegrationTests {
    func assertThat(_ sut: ListViewController, isRendering comments: [ImageComment], file: StaticString = #file, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedComments() == comments.count else {
            return XCTFail("Expected \(comments.count) images, got \(sut.numberOfRenderedComments()) instead.", file: file, line: line)
        }
        
        comments.enumerated().forEach { index, comment in
            assertThat(sut, hasViewConfiguredFor: comment, at: index, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    func assertThat(_ sut: ListViewController, hasViewConfiguredFor comment: ImageComment, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.comment(at: index)
        
        guard let cell = view as? ImageCommentCell else {
            return XCTFail("Expected \(ImageCommentCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.usernameLabel.text, comment.username, "Expected username text to be \(comment.username) for comment at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.messageLabel.text, comment.message, "Expected username text to be \(comment.username) for comment at index (\(index))", file: file, line: line)
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
