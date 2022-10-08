//
//  BookManagerTests.swift
//  BookManagerTests
//
//  Created by 相場智也 on 2022/09/21.
//

import XCTest
@testable import BookManager

final class BookManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testFetchUsers() async {
        let model = UserLoginModel()
        do {
            let res = try await model.fetchUser()
            XCTAssertEqual(res[0].id, "KRDfMH9C84xQ9ZAwTbXE")
            XCTAssertEqual(res[0].name, "tohki")
            XCTAssertEqual(res[0].isRoot, true)
        }catch{
            print("ERROR Message", error.localizedDescription)
        }
    }
    
    func testFetchBooks() async {
        let model = BookManagementModel()
        do {
            let res = try await model.fetchBooks()
            XCTAssertEqual(res[0].title, "［増補改訂］良いコードを書く技術 ── 読みやすく保守しやすいプログラミング作法")
        }catch {
            print(error)
        }
    }
    func testFetchBookData() async {
                
        let model = BookRegisterModel()
        do {
            let res = try await model.fetchBookInfo(ISBNCode: "978-4-02-331568-6")
            XCTAssertEqual(res.title, "ＴＯＥＩＣ　Ｌ＆Ｒ　ＴＥＳＴ")
        }catch{
            print(error)
        }
        
        do {
            let res = try await model.fetchBookInfo(ISBNCode: "")
        }catch{
            print("ERROR", error.localizedDescription)
        }
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
