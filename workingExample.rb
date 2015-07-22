
# standalone ruby example not yet turned into Logstash plugin

# http://gimite.net/doc/google-drive-ruby/
# sudo gem install google-api-client
# sudo gem install google_drive
require 'google/api_client'
require "google_drive"

SERVICE_ACCOUNT_EMAIL = 'YOUR SERVICE ACCOUNT EMAIL HERE@developer.gserviceaccount.com'
PRIVATE_KEY_FILE_PATH = "PATH TO KEY FILE.p12"
KEY_SECRET = "notasecret"

# google uuid of the spreadsheet in question
SPREADSHEET_KEY =  "GOOGLE ASSIGNED UUID FOR SPREADSHEET FROM URL"

# name of the worksheet to pull inside that
WORKSHEET_NAME = "Record"


@client = Google::APIClient.new(
  :application_name => "ESGSpreadsheetPull",
  :application_version => "1.0")

key = Google::APIClient::KeyUtils.load_from_pkcs12(PRIVATE_KEY_FILE_PATH, KEY_SECRET)

@client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => "https://www.googleapis.com/auth/drive",
  :issuer => SERVICE_ACCOUNT_EMAIL,
  :signing_key => key)
  
@client.authorization.fetch_access_token!


session = GoogleDrive.login_with_oauth(@client.authorization.access_token)

ws = session.spreadsheet_by_key(SPREADSHEET_KEY).worksheet_by_title(WORKSHEET_NAME)

csv = ws.export_as_string()

print csv