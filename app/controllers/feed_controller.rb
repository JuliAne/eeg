class FeedController < ApplicationController
  def rss
    @posts = Post.find(:all)
    render :layout => false
    #response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  def atom
    @posts = Post.find(:all)
    render :layout => false
  end
end
