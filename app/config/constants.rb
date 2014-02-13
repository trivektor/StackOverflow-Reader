STACK_EXCHANGE_API_HOST = 'https://api.stackexchange.com/2.1/'
STACK_OVERFLOW_SITE_PARAM = 'stackoverflow'
STACK_EXCHANGE_SECRET = 'X2qdwhrwW4F2AyAjnshkLA(('
STACK_EXCHANGE_KEY = 'UFdZZFvyZOGj*qwOEaPUTA(('
STACK_EXCHANGE_CLIENT_ID = 2508
STACK_EXCHANGE_SCOPES = %w( read_inbox no_expiry write_access private_info )
STACK_EXCHANGE_REDIRECT_URI = 'http://stackmotion.herokuapp.com'
APP_KEYCHAIN_IDENTIFIER = 'StackOverflowMotionKeychain'
APP_KEYCHAIN_ACCOUNT = 'stack_overflow_motion'
OAUTH_URL = "https://stackexchange.com/oauth/dialog?client_id=#{STACK_EXCHANGE_CLIENT_ID}&scope=#{STACK_EXCHANGE_SCOPES.join(',')}&redirect_uri=#{STACK_EXCHANGE_REDIRECT_URI}"
PAGE_SIZE = 100
NAVIGATION_BAR_COLOR = '#2ed65a'.uicolor
NAVIGATION_BAR_FONT = 'HelveticaNeue-Medium'.uifont(20)