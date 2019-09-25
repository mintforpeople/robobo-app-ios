//
//  CommandSanitizer.swift

//
//  Created by Luis on 06/06/2019.
//


public class CommandSanitizer: NSObject {
    
    
    
    private static func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            let finalResult = results.map {
                String(text[Range($0.range, in: text)!])
            }
            return finalResult
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    static public func sanitize(_ input: String) -> String{
        let regex = try? NSRegularExpression(pattern: "(?<=\\w\\w\\w\":)\\d++")
        
        let text:NSMutableString =  NSMutableString(string: input)
        
        regex?.replaceMatches(in: text , options: .reportProgress, range: NSRange(location: 0,length: text.length), withTemplate: "\"$0\"")
        
        return text as String
        
    }
}
