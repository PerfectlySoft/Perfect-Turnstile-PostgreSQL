//
//  Account.swift
//  PerfectTurnstilePostgreSQL
//
//  Created by Jonathan Guthrie on 2016-10-17.
//
//

import Turnstile
import TurnstileCrypto
import PostgresStORM
import StORM

open class AuthAccount : PostgresStORM, Account {
	public var uniqueID: String = ""

	public var username: String = ""
	public var password: String = ""

	public var facebookID: String = ""
	public var googleID: String = ""

	public var firstname: String = ""
	public var lastname: String = ""
	public var email: String = ""

	public var internal_token: AccessTokenStore = AccessTokenStore()

	override open func table() -> String {
		return "users"
	}

	public func id(_ newid: String) {
		uniqueID = newid
	}

	// Need to do this because of the nature of Swift's introspection
	override open func to(_ this: StORMRow) {
		uniqueID	= this.data["uniqueID"] as! String
		username	= (this.data["username"] as! String)
		password	= (this.data["password"] as! String) // lets not read the password!
		facebookID	= (this.data["facebookID"] as! String)
		googleID	= (this.data["googleID"] as! String)
		firstname	= (this.data["firstname"] as! String)
		lastname	= (this.data["lastname"] as! String)
		email		= (this.data["email"] as! String)
	}

	func rows() -> [AuthAccount] {
		var rows = [AuthAccount]()
		for i in 0..<self.results.rows.count {
			let row = AuthAccount()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}


	// Create the table if needed
	public func setup() {
		do {
			try sql("CREATE TABLE IF NOT EXISTS users (\"uniqueID\" varchar COLLATE \"default\",\"username\" varchar COLLATE \"default\",\"password\" varchar COLLATE \"default\", \"facebookID\" varchar COLLATE \"default\", \"googleID\" varchar COLLATE \"default\", \"firstname\" varchar COLLATE \"default\", \"lastname\" varchar COLLATE \"default\", \"email\" varchar COLLATE \"default\", CONSTRAINT \"users_key\" PRIMARY KEY (\"uniqueID\") NOT DEFERRABLE INITIALLY IMMEDIATE)", params: [])
		} catch {
			print(error)
		}
	}

	func make() throws {
		print("IN MAKE")
		do {
			password = BCrypt.hash(password: password)
			try create() // can't use save as the id is populated
		} catch {
			print(error)
		}
	}
	func get(_ un: String, _ pw: String) throws -> AuthAccount {
		let cursor = StORMCursor(limit: 1, offset: 0)
		do {
			try select(whereclause: "username = $1", params: [un], orderby: [], cursor: cursor)
			to(self.results.rows[0])

			let verifyPw = try BCrypt.verify(password: pw, matchesHash: password)
			if !verifyPw {
				print("Invalid password for username: \(un)")
				throw StORMError.noRecordFound
			}
			return self
		} catch {
			print(error)
			throw StORMError.noRecordFound
		}
	}
	func exists(_ un: String) -> Bool {
		do {
			try select(whereclause: "username = $1", params: [un], orderby: [], cursor: StORMCursor(limit: 1, offset: 0))
			if results.rows.count == 1 {
				return true
			} else {
				return false
			}
		} catch {
			print("Exists error: \(error)")
			return false
		}
	}
}


