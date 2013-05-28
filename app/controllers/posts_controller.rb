class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    @post = Post.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end
  end

  def my
    @posts = Post.where("user_id = ?", current_user.id).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    @post = Post.new

    respond_to do |format|
      format.html # my.html.erb
      format.json { render :json => @posts }
    end
  end

  def replies
    @posts = Post.where("content LIKE ?", "%#{current_user.username}%").order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    @post = Post.new

    respond_to do |format|
      format.html # replies.html.erb
      format.json { render :json => @posts }
    end
  end

  def idols
    @user = current_user || User.find(params[:id])
    @posts = Post.where("user_id" => @user.idols).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    @post = Post.new

    respond_to do |format|
      format.html # idols.html.erb
      format.json { render :json => @posts }
    end
  end

  def groupies
    @user = current_user || User.find(params[:id])
    @posts = Post.where("user_id" => @user.groupies).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    @post = Post.new

    respond_to do |format|
      format.html # groupies.html.erb
      format.json { render :json => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/flagged
  def flagged
    @posts = Post::flagged
  end

  # THIS TOGGLES THE FLAG ON THE POST
  # it's just easier to implement that way
  # GET /posts/1/flag
  def flag
    @post = Post.find(params[:post_id])

    if (@post.flagged?)
      @post.unflag!
    else
      @post.flag!
    end

    respond_to do |format|
      format.js
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, :notice => 'Post was successfully created.' }
        format.json { render :json => @post, :status => :created, :location => @post }
        format.js 
      else
        format.html { render :action => "new" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
        format.js 
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])

    if (@post.flagged?)
      @post.unflag
    end
    
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      #format.json { head :no_content }
      format.json { render :nothing => true }
      format.js { render :nothing => true }
    end
  end
end
