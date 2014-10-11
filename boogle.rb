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
      Page.ensure_index :pageId, :unique => true
      Page.create({"pageId" => params[:pageId], "content" => params[:content]})
      response.status = 204
    rescue Mongo::OperationFailure => E
      { "error" => "pageId already exists." }.to_json
    end
  end
end
