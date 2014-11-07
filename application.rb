require './dependencies.rb'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
	@session_id = Digest::MD5.hexdigest(request.ip + request.user_agent + Time.now.to_s)
	@description = "We tell you why stuff happens."

	request_data = RequestData.new({
		session_id: @session_id,
		user_agent: request.user_agent,
		ip: request.ip
	})

	request_data.save

	erb :index
end

get '/iphone-better-than-android' do
	@session_id = Digest::MD5.hexdigest(request.ip + request.user_agent + Time.now.to_s)
	@title = "iPhone is better than Android"
	@description = "In case you are still defending android here are the final arguments that will change your mind."
	@image = "/images/2014/iphone-better-android/post-image.jpg"

	request_data = RequestData.new({
		session_id: @session_id,
		user_agent: request.user_agent,
		ip: request.ip
	})

	request_data.save

	erb :iphone_better, :layout => :main_layout
end

get '/you-got-virus-and-malware' do
	@session_id = Digest::MD5.hexdigest(request.ip + request.user_agent + Time.now.to_s)
	@title = "Your computer got virus and malware"
	@description = "The main reason why your computer is always getting new malware installed."
	@image = "/images/2014/you-got-virus-and-malware/post-image.jpg"

	request_data = RequestData.new({
		session_id: @session_id,
		user_agent: request.user_agent,
		ip: request.ip
	})

	request_data.save

	erb :virus, :layout => :main_layout
end

get '/you-struggle-with-ios' do
	@session_id = Digest::MD5.hexdigest(request.ip + request.user_agent + Time.now.to_s)
	@title = "You struggle with iOS"
	@description = "The main reason why you struggle with iOS."
	@image = "/images/2014/you-struggle-with-ios/post-image.jpg"

	request_data = RequestData.new({
		session_id: @session_id,
		user_agent: request.user_agent,
		ip: request.ip
	})

	request_data.save

	erb :struggle_with_ios, :layout => :main_layout
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
