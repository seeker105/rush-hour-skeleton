module ClientParser

	def get_relative_paths(client)
		urls = client.most_to_least_frequent_urls
		@urls_with_requests = Hash.new([])
		urls.map do |url|
			@urls_with_requests[url] += client.find_payload_requests_by_relative_path(url) if @client.find_payload_requests_by_relative_path(url)
		end
		@urls_with_requests.keys.map { |url| URI.parse(url).path }
	end

	def parse_event_data(identifier, eventname)
		@event_text = "Number of " + eventname + "s: "
		@identifier = identifier
		client = Client.find_by(identifier: identifier)
		client_events_exist?(client, eventname)
	end

	def client_events_exist?(client, eventname)
		if client && client.events.find_by(name: eventname)
			event_hours = find_and_format_event_hours(client, eventname)
			create_events_by_hour_hash(event_hours)
			true
		else
			false
		end
	end

	def find_and_format_event_hours(eventname)
		client.events.find_by(name: eventname).payload_requests.where(client: client.id).pluck(:requested_at).map do |time|
			Time.parse(time).strftime("%H")
		end
	end

	def create_events_by_hour_hash(event_hours)
		@events_by_hour = event_hours.inject(Hash.new(0)) { |hash, hour| hash[hour] += 1; hash }
	end

	def get_client_and_events(identifier)
		@client = Client.find_by(identifier: identifier)
		@event_names = @client.events.pluck(:name).uniq
	end

	def find_relative_path_payload_requests(identifier, relativepath)
		@client = Client.find_by(identifier: identifier)
		url = "http://#{identifier}.com/#{relativepath}"
		@requests = @client.find_payload_requests_by_relative_path(url)
	end
end
