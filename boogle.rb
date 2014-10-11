class BoogleApp < Sinatra::Base
	get '/search' do
    result = Boogle::API.search(params[:query])
    render :json => result
	end
end
