class UsersController < ApplicationController
	load_and_authorize_resource

	before_filter :skip_password_attribute, :only => :update

    # basic CRUD
	def index
		@users = User.all
		respond_to do |format|
			format.html
			format.json { render :json => @users }
		end
	end

	def show
		@user = User.find(params[:id])

		respond_to do |format|
			format.html
			format.json { render :json => @user }
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	# delete user
	# must also delete their posts
	# and 'unidolize' their idols
	def destroy
	    @user = User.find(params[:id])
	    @posts = Post.where("user_id = ?", @user.id)

	    @user.idols.each do |i|
	    	@user.unidolize(i)
	    end

	    @posts.each do |p|
	    	p.destroy
	    end

	     @user.destroy

	    respond_to do |format|
	      format.html { redirect_to users_url }
	      #format.json { head :no_content }
	      format.json { render :nothing => true }
	      format.js { render :nothing => true }
	    end
	end

	def update
		@user = User.find(params[:id])

		respond_to do |format|
			if @user.update_attributes(params[:user])
        		format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        		format.json { head :no_content }
      		else
        		format.html { render :action => "edit" }
        		format.json { render :json => @user.errors, :status => :unprocessable_entity }
      		end
		end
	end

	# Idols / Groupies
	def idols
		unless params[:id].nil?
			@users = User.find(params[:id]).idols
		else
			@users = current_user.idols 
		end

		respond_to do |format|
			format.html
			format.json { render :json => @users }
		end
	end

	def groupies
		unless params[:id].nil?
			@users = User.find(params[:id]).groupies
		else
			@users = current_user.groupies 
		end

		respond_to do |format|
			format.html
			format.json { render :json => @users }
		end
	end

	def idolize
		@user = User.find(params[:id])
		current_user.idolize!(@user)
		respond_to do |format|
			format.html
			format.json { render :nothing => true }
			format.js 
		end
	end

	def unidolize
		@user = User.find(params[:id])
		current_user.unidolize!(@user)

		respond_to do |format|
			format.html
			format.json { render :nothing => true }
			format.js 
		end		
	end	
end