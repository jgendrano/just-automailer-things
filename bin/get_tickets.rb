require 'json'

variable = `curl 'https://guardrail.zendesk.com/api/v2/search.json' \
-G --data-urlencode "query=type:ticket requester_id:"2751525483" status:new" \
-v -u #{ENV["ZD_EMAIL"]}/token:#{ENV["ZD_TOKEN"]}`
tickets_string = JSON.pretty_generate(JSON.load(variable))
tickets_json = (JSON.parse(variable))
results = tickets_json["results"]


scriptrock = "support@scriptrock.com - Daily Email Test"
upguard = "support@upguard.com - Daily Email Test"

def curl_post(arguments)
  arguments = arguments.join(", ") if arguments.instance_of? Array
  `curl https://guardrail.zendesk.com/api/v2/tickets.json \
  -d '{"ticket": {"subject": "NOTIFICATION: Support Emails", "comment": { "body": "The following support test(s) did not come through: #{arguments}" }}}' \
  -H "Content-Type: application/json" -v -u #{ENV["ZD_EMAIL"]}/token:#{ENV["ZD_TOKEN"]} -X POST`
end

if tickets_string.include?(scriptrock) && tickets_string.include?(upguard)
  results.each do |ticket|
    `curl https://guardrail.zendesk.com/api/v2/tickets/#{ticket["id"]}.json \
      -v -u #{ENV["ZD_EMAIL"]}/token:#{ENV["ZD_TOKEN"]} -X DELETE
    `
  end
elsif tickets_string.include?(scriptrock) && !(tickets_string.include?(upguard))
  curl_post(upguard)
elsif !(tickets_string.include?(scriptrock)) && tickets_string.include?(upguard)
  curl_post(scriptrock)
else
  arguments = [upguard, scriptrock]
  curl_post(arguments)
end
