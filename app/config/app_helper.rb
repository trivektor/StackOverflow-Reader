module AppHelper
  
  def decodeHTMLEntities(rawString)
    NSString.alloc.initWithString(rawString).stringByDecodingHTMLEntities
  end
  
end