class SearchController < ApplicationController
	def results
		#@posts = Post.search(params[:keyword]).paginate(:page => params[:page], :per_page => 3)
		@posts = Post.where("posts.content LIKE ?", "%#{params[:keyword]}%").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)

		respond_to do |format|
			format.html
			format.json { render :json => @posts }
		end
	end
end
