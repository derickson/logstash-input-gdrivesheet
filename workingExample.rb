
# standalone ruby example not yet turned into Logstash plugin

# http://gimite.net/doc/google-drive-ruby/
# sudo gem install google-api-client
# sudo gem install google_drive
require 'google/api_client'
require "google_drive"

# Config things
SERVICE_ACCOUNT_EMAIL = 'YOUR SERVICE ACCOUNT EMAIL HERE@developer.gserviceaccount.com'   # you have to share the spreadsheet with this person for this to work
PRIVATE_KEY_FILE_PATH = "PATH TO KEY FILE.p12"  # download this service account key from the google dev console for your app
KEY_SECRET = "notasecret" # literally the password for every google generated key, well known secret no point in protecting it
SPREADSHEET_KEY =  "GOOGLE ASSIGNED UUID FOR SPREADSHEET FROM URL" # google uuid of the spreadsheet in question


WORKSHEET_NAME = "Record" # name of the worksheet to pull inside that

# create a new client
@client = Google::APIClient.new(
  :application_name => "ESGSpreadsheetPull",
  :application_version => "1.0")

# prep key file
key = Google::APIClient::KeyUtils.load_from_pkcs12(PRIVATE_KEY_FILE_PATH, KEY_SECRET)

# auth as the app's service account to google APIs ( less complicated than a client+server OAuth2 handshake, as we don't have to save any tokens )
@client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => "https://www.googleapis.com/auth/drive",
  :issuer => SERVICE_ACCOUNT_EMAIL,
  :signing_key => key)
@client.authorization.fetch_access_token!

# start a new session to google REST api using temp auth token
session = GoogleDrive.login_with_oauth(@client.authorization.access_token)


# prove that we have access to the spreadsheet by printing it out as CSV
ws = session.spreadsheet_by_key(SPREADSHEET_KEY).worksheet_by_title(WORKSHEET_NAME)

csv = ws.export_as_string()

print csv