import Foundation

// Wait for the user to type something in the console, and return what
// they type as a String with the trailing newline character removed.
func getln() -> String {
    let stdin = FileHandle.standardInput
    var input = NSString(data: stdin.availableData, encoding: String.Encoding.utf8.rawValue)
    input = input!.trimmingCharacters(in: CharacterSet.newlines) as NSString?
    return input! as String
}
