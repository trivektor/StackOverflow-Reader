class AppHelper

  class << self

    def access_token
      SSKeychain.passwordForService('access_token', account:APP_KEYCHAIN_ACCOUNT)
    end

    def getAccountUsername
      SSKeychain.passwordForService('username', account:APP_KEYCHAIN_ACCOUNT)
    end

    def flashAlert(message, inView:view)
      # TO BE IMPLEMENTED
    end

    def flashError(message, inView:view)
      # TO BE IMPLEMENTED
    end

    def decodeHTMLEntities(rawString)
      NSString.alloc.initWithString(rawString).stringByDecodingHTMLEntities
    end

  end

end