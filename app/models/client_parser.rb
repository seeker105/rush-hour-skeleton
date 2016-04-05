module ClientParser

	def find_client(identifier)
		Client.find_by(identifier: identifier)
	end

	def parse_client(identifier)
		@client = find_client(identifier)
		@identifier = @client.identifier if @client
	end

	def generate_urls_with_requests_hash(client)
		urls = client.most_to_least_frequent_urls
		@urls_with_requests = urls.inject(Hash.new([])) do |hash, url|
			hash[url] += @client.find_payload_requests_by_relative_path(url) if @client.find_payload_requests_by_relative_path(url)
			hash
		end
		@urls_with_requests.keys.map { |url| URI.parse(url).path }
	end

	def create_relativepaths(urls_with_requests)
		urls_with_requests.keys.map { |url| URI.parse(url).path }
	end

	def parse_event_data(identifier, eventname)
		@event_text = "Number of " + eventname + "s: "
		@identifier = identifier
		client = find_client(identifier)
		client_events_exist?(client, eventname)
	end

	def client_events_exist?(client, eventname)
		if client && client.events.find_by(name: eventname)
			event_hours = find_and_format_event_hours(eventname, client)
			create_events_by_hour_hash(event_hours)
			true
		else
			false
		end
	end

	def find_and_format_event_hours(eventname, client)
		client.events.find_by(name: eventname).payload_requests.where(client: client.id).pluck(:requested_at).map do |time|
			Time.parse(time).strftime("%H")
		end
	end

	def create_events_by_hour_hash(event_hours)
		@events_by_hour = event_hours.inject(Hash.new(0)) { |hash, hour| hash[hour] += 1; hash }
	end

	def get_events(identifier)
		@client = find_client(identifier)
		@event_names = @client.events.pluck(:name).uniq
	end

	def find_relative_path_payload_requests(identifier, relativepath)
		@client = find_client(identifier)
		url = "http://#{identifier}.com/#{relativepath}"
		@requests = @client.find_payload_requests_by_relative_path(url)
	end
end
