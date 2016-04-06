module PayloadParser

		def validate_request(identifier, params)
			params = params_parser(params, identifier)
			# binding.pry
			return [403, "Application Not Registered"] unless client_exists?(identifier)
			# binding.pry
			return [400, "Payload Not Valid"] if params.values.include?(nil)
			# binding.pry
			payload = create_payload(params, identifier)
			binding.pry
			if payload.save
				return [200, "Payload Request Created"]
			else
				return [403, "Already Received Request"]
			end
				# binding.pry
				# binding.pry
			# return [403, "Already Received Request"] if payload_exists?(params)
			# [200, "Payload Request Created"]
		end
	# BREAK UP INTO SMALLER METHODS
	def params_parser(params, identifier)
		params = JSON.parse(params['payload']) if params['payload']
		{
		 'url' => params['url'],
		 'requested_at' => params['requestedAt'],
		 'responded_in' => params['respondedIn'],
		 'referrer' => params['referredBy'],
		 'request_type' => params['requestType'],
		 'event' => params['eventName'],
		 'u_agent' => params['userAgent'],
		 'resolution_width' => params['resolutionWidth'],
		 'resolution_height' => params['resolutionHeight'],
		 'ip' => params['ip'],
		 'identifier' => identifier,
		 'root_url' => params['url']
	  }
	end


	def client_exists?(identifier)
		Client.exists?(identifier: identifier)
	end

	def platform(params)
		platform = UserAgent.parse(params['u_agent']).platform
	end

	def browser(params)
		browser = UserAgent.parse(params['u_agent']).browser
	end

	# def payload_valid?(params)
	# 	binding.pry
	# 	pr = PayloadRequest.new(url: Url.find_or_create_by(address: params['url']),
	#                           referrer: Referrer.find_or_create_by(address: params['referrer']),
	#                           request_type: RequestType.find_or_create_by(verb: params['request_type']),
	#                           event: Event.find_or_create_by(name: params['event']),
	#                           u_agent: UAgent.find_or_create_by(browser: browser(params), platform: platform(params)),
	#                           resolution: Resolution.find_or_create_by(width: params['resolution_width'], height: params['resolution_height']),
	#                           ip: Ip.find_or_create_by(address: params['ip']),
	# 												  requested_at: params['requested_at'],
	#                           responded_in: params['responded_in'],
	# 												  client: Client.find_by(identifier: params['identifier'])
	#                         	)
	# 													binding.pry
	# 	pr.valid?
	# end

	def payload_exists?(params)
		# platform = UserAgent.parse(params['u_agent']).platform
		# browser = UserAgent.parse(params['u_agent']).browser
		# PayloadRequest.exists?(url: Url.find_by(address: params['url']),
	  #                        referrer: Referrer.find_by(address: params['referrer']),
	  #                        request_type: RequestType.find_by(verb: params['request_type']),
	  #                        event: Event.find_by(name: params['event']),
	  #                        u_agent: UAgent.find_by(browser: browser, platform: platform),
	  #                        resolution: Resolution.find_by(width: params['resolution_width'], height: params['resolution_height']),
	  #                        ip: Ip.find_by(address: params['ip']),
		# 											 requested_at: params['requested_at'],
	  #                        responded_in: params['responded_in'],
		# 											 client: Client.find_by(identifier: params['identifier'])
	  #                   		 )
	end

	def add_to_database(params, identifier)
		params = params_parser(params, identifier)
		platform = UserAgent.parse(params['u_agent']).platform
		browser = UserAgent.parse(params['u_agent']).browser
		PayloadRequest.create(url: Url.find_or_create_by(address: params['url']),
													referrer: Referrer.find_or_create_by(address: params['referrer']),
													request_type: RequestType.find_or_create_by(verb: params['request_type']),
													event: Event.find_or_create_by(name: params['event']),
													u_agent: UAgent.find_or_create_by(browser: browser, platform: platform),
													resolution: Resolution.find_or_create_by(width: params['resolution_width'], height: params['resolution_height']),
													ip: Ip.find_or_create_by(address: params['ip']),
													requested_at: params['requested_at'],
													responded_in: params['responded_in'],
													client: Client.find_by(identifier: params['identifier'])
													)
	end


	def create_payload(params, identifier)
		pr = PayloadRequest.new(url: Url.where(address: params['url']).first_or_create,
														referrer: Referrer.where(address: params['referrer']).first_or_create,
														request_type: RequestType.where(verb: params['request_type']).first_or_create,
														event: Event.where(name: params['event']).first_or_create,
														u_agent: UAgent.where(browser: browser(params), platform: platform(params)).first_or_create,
														resolution: Resolution.where(width: params['resolution_width'], height: params['resolution_height']).first_or_create,
														ip: Ip.where(address: params['ip']).first_or_create,
														requested_at: params['requested_at'],
														responded_in: params['responded_in'],
														client: Client.find_by(identifier: params['identifier'])
														)
	end



end
