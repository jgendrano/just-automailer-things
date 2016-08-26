require 'gmail'
require 'figaro'

username = ENV["GMAIL_USERNAME"]
password = ENV["GMAIL_PASSWORD"]
Gmail.connect(username, password) do |gmail|

  addresses = ENV["SEND_EMAIL"].split(" ")

  addresses.each do |address|
    email = gmail.compose do
      to address
      subject "support@upguard.com - Daily Email Test"
      body "Did you get this? This is a test for the Upguard address!"
    end
    email.deliver!
  end

end
