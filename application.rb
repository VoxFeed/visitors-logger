require './dependencies.rb'

set :public_folder, File.dirname(__FILE__) + '/public'


get '/iphone-better-than-android' do
	@session_id = Digest::MD5.hexdigest(request.ip + request.user_agent + Time.now.to_s)

	request_data = RequestData.new({
		session_id: @session_id,
		user_agent: request.user_agent,
		ip: request.ip
	})

	request_data.save

	erb :iphone_better
end

get '/you-got-virus-and-malware' do
	@session_id = Digest::MD5.hexdigest(request.ip + request.user_agent + Time.now.to_s)

	request_data = RequestData.new({
		session_id: @session_id,
		user_agent: request.user_agent,
		ip: request.ip
	})

	request_data.save

	erb :virus
end


post '/capture_request' do
	puts params
	if params[:session_id]
		@request_data = RequestData.find(params[:session_id])
		@request_data.loads_assets = false
		@request_data.save
	end
end

post '/verify_js' do
	puts params
	request_data = RequestData.find(params[:session_id])
	if request_data
		request_data.runs_javascript = true
		request_data.save
	end
	puts request_data
end
