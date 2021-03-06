class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
    
  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @picture = @post.picture
    @post.has_date_from = true unless @post.date_from.nil?
    @post.has_time_from = true unless @post.time_from.nil?
    @post.has_date_to = true unless @post.date_to.nil?
    @post.has_time_to = true unless @post.time_to.nil?
  end

  # POST /posts
  # POST /posts.xml
  def create
    #make date field empty if they are not used
    make_empty("date_from") if params[:post].fetch("has_date_from") == "false"
    make_empty("date_to") if params[:post].fetch("has_date_to") == "false" or params[:post].fetch("has_date_from") == "false"
    #if there is no date, then we need no time
    make_empty("time_from") if params[:post].fetch("has_time_from") == "false" or params[:post].fetch("has_date_from") == "false"
    make_empty("time_to") if params[:post].fetch("has_time_to") == "false" or params[:post].fetch("has_date_to") == "false" or params[:post].fetch("has_date_from") == "false"
    
    #need to assign before @post = Post.new(params[:post])
    params[:post]['has_date_from'] == "true" ? params[:post]['has_date_from'] = true : params[:post]['has_date_from'] = false
    params[:post]['has_time_from'] == "true" ? params[:post]['has_time_from'] = true : params[:post]['has_time_from'] = false
    params[:post]['has_date_to'] == "true" ? params[:post]['has_date_to'] = true : params[:post]['has_date_to'] = false
    params[:post]['has_time_to'] == "true" ? params[:post]['has_time_to'] = true : params[:post]['has_time_to'] = false
    
    @post = Post.new(params[:post])
    #additionally build a picture (but not save it until the post is saved!) (this is the distinction between build and create)
    @picture = @post.build_picture(params[:picture])
    #set the picture_id of the post to the picture id
    @post.picture_id = @picture.id
    
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])
    @picture = @post.picture
    #make date field empty if they are not used
    make_empty("date_from") if params[:post].fetch("has_date_from") == "false"
    make_empty("date_to") if params[:post].fetch("has_date_to") == "false" or params[:post].fetch("has_date_from") == "false"
    #if there is no date, then we need no time
    make_empty("time_from") if params[:post].fetch("has_time_from") == "false" or params[:post].fetch("has_date_from") == "false"
    make_empty("time_to") if params[:post].fetch("has_time_to") == "false" or params[:post].fetch("has_date_to") == "false" or params[:post].fetch("has_date_from") == "false"
    
    params[:post]['has_date_from'] == "true" ? params[:post]['has_date_from'] = true : params[:post]['has_date_from'] = false
    params[:post]['has_time_from'] == "true" ? params[:post]['has_time_from'] = true : params[:post]['has_time_from'] = false
    params[:post]['has_date_to'] == "true" ? params[:post]['has_date_to'] = true : params[:post]['has_date_to'] = false
    params[:post]['has_time_to'] == "true" ? params[:post]['has_time_to'] = true : params[:post]['has_time_to'] = false
    
    params[:post][:existing_element_attributes] ||= {}
    
    respond_to do |format|
      if @post.update_attributes(params[:post]) and @picture.update_attributes(params[:picture])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
  def toggle
    respond_to do |format|
      format.js do
        render :update do |page|
          if params[:value] == "true"
            page.show(params[:element])
          else
            page.hide(params[:element])
          end
        end
      end
    end
  end
  
  private
  def make_empty(field)
    params[:post][field+"(1i)"] = ""
    params[:post][field+"(2i)"] = ""
    params[:post][field+"(3i)"] = ""
    params[:post][field+"(4i)"] = ""
    params[:post][field+"(5i)"] = ""
  end
end
