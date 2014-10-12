IncompleteParamsException = Class.new(StandardError)

class BoogleApp < Sinatra::Base

  configure do
    MongoMapper.database = ENV['MONGODB_DB'] || "boogle"
  end

  get '/search' do
    result = ::Boogle::API.search(params[:query])
    render :json => result
	end

  get '/index' do
    content_type :json
    begin
      raise IncompleteParamsException if (params[:pageId].nil? || params[:content].nil?)
      Page.ensure_index :pageId, :unique => true
      Page.create({"pageId" => params[:pageId], "content" => params[:content]})
      response.status = 204
    rescue Mongo::OperationFailure => E
      response.status = 200
      { "error" => "pageId already exists." }.to_json
    rescue IncompleteParamsException
      response.status = 500
      { "error" => "pageId and content params are required. "}.to_json
    end
  end
end
