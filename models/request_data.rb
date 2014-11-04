require 'mysql2'
class RequestData
	attr_accessor :session_id, :user_agent, :ip, :runs_javascript, :loads_assets

	def initialize(attributes = {})
		self.session_id      = attributes[:session_id] || nil
		self.user_agent      = attributes[:user_agent] || nil
		self.ip              = attributes[:ip] || nil
		self.runs_javascript = attributes[:runs_javascript] || nil
		self.loads_assets    = attributes[:loads_assets] || nil
	end

	def save
		attributes = {}
		
		attributes[:session_id]      = session_id if !session_id.nil?
		attributes[:user_agent]      = user_agent if !user_agent.nil?
		attributes[:ip]              = ip if !ip.nil?
		attributes[:runs_javascript] = runs_javascript if !runs_javascript.nil?
		attributes[:loads_assets]    = loads_assets if !runs_javascript.nil?

		if new_record?
			results = RequestData.create(attributes)
		else
			results = RequestData.update(attributes)
		end

		results
	end

	def new_record?
		RequestData.find(session_id).nil?
	end

	def self.get_client
		client  = Mysql2::Client.new({
			host: ENV['MYSQL_HOST'],
			username: ENV['MYSQL_USERNAME'],
			password: ENV['MYSQL_PASSWORD'],
			database: ENV['MYSQL_DATABASE']
		})
	end

	def self.create(attributes = {})
		client = RequestData.get_client
		query_string = %{
			INSERT INTO requests_data (session_id, user_agent, ip)
			VALUES (
				"#{attributes[:session_id]}",
				"#{attributes[:user_agent]}",
				"#{attributes[:ip]}"
			)
		}

		puts query_string

		results = client.query(query_string)
		client.close
		client = nil
		results
	end

	def self.update(attributes={})
		client = RequestData.get_client

		set_string = ''
		session_id = attributes.delete(:session_id)
		attributes.each do |field, value|
			next if value.nil?
			puts value.to_s + " => " + value.class.to_s
			if value.class.to_s == 'TrueClass' || value.class.to_s == 'FalseClass'
				set_string << "#{field}=#{value},"
			else
				set_string << "#{field}=\"#{value}\","
			end
		end

		query_string = %{
			UPDATE
				requests_data
			SET #{set_string.chomp(',')}
			WHERE
				session_id = "#{session_id}"
		}

		puts query_string

		results = client.query(query_string)
		client.close
		client = nil
		results
	end

	def self.find(session_id)
		result       = nil
		client = RequestData.get_client
		query_string = %{
			SELECT
				session_id,
				user_agent,
				ip,
				runs_javascript,
				loads_assets
			FROM
				requests_data
			WHERE
				session_id = "#{session_id}"
			LIMIT 1
		}

		client.query(query_string).each do |record|
			result = RequestData.new({
				session_id: record['session_id'],
				user_agent: record['user_agent'],
				ip: record['ip'],
				runs_javascript: record['runs_javascript'],
				loads_assets: record['loads_assets']
			})
		end
		client.close
		client = nil
		result
	end
end