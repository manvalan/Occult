//
//  StreamReader.swift
//  Occult
//
//  Created by Michele Bigi on 27/05/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

public class StreamReader{
    let encoding:String.Encoding
    let chunkSize:Int
    var fileHandle:FileHandle!
    let buffer:NSMutableData!
    let delimData:NSData!
    var atEof:Bool = false
    
    init?(path:String, delimiter:String = "\n", encoding:String.Encoding = String.Encoding.utf8, chunkSize:Int = 4096){
        self.chunkSize = chunkSize
        self.encoding = encoding
        
        
        if let fileHandle = FileHandle(forReadingAtPath:path){
            self.fileHandle = fileHandle
        }else{
            return nil
        }
        
       
        if let delimData = delimiter.data(using: String.Encoding.utf8){
            self.delimData = delimData as NSData
        }else{
            return nil
        }
        
        //chunkSize
        if let buffer = NSMutableData(capacity:chunkSize){
            self.buffer = buffer
        }else{
            return nil
        }
    }
    
    deinit{
        self.close()
    }
    
    //EOF
    func nextLine()->String?{
        if atEof{
            return nil
        }
        
        //NSRange
        var range = buffer.range(of: delimData as Data,in:NSMakeRange(0,buffer.length))
        //range location NSNotFound、
        while range.location == NSNotFound {
            //chunkSize
            var tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count == 0{
                //
                atEof = true
                if buffer.length > 0{
                    //
                    let line = NSString(data:buffer as Data,encoding:encoding.rawValue);
                    buffer.length = 0
                    return String( describing: line )
                }
                
                return nil
            }
            buffer.append(tmpData)
            
            range = buffer.range(of: delimData as Data,in:NSMakeRange(0,buffer.length))
        }
        
        //NSRange
        let line = NSString(data: buffer.subdata(with: NSMakeRange(0, range.location)),
                            encoding: encoding.rawValue)
        
        buffer.replaceBytes(in: NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        
        
        return String( describing: line )
    }
    
    
    func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.length = 0
        atEof = false
    }

    func close() -> Void {
        if fileHandle != nil {
            fileHandle.closeFile()
            fileHandle = nil
        }
    }
}

//extension StreamReader : Sequence {
//    public func generate() -> GeneratorOf<String> {
//        return GeneratorOf<String> {
//            return self.nextLine()
//        }
//    }
//}
