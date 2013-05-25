class SearchController < ApplicationController
	def results
		@posts = Post.search(params[:keyword])

		respond_to do |format|
			format.html
			format.json { render :json => @posts }
		end
	end
end
