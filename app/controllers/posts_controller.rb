class PostsController < ApplicationController
	before_action :authenticate_user!
	def create
		@post = current_user.posts.new(create_post_params)
		@post.save
	end

	private
	def create_post_params
		params.require(:post).permit(:content, :date_publish, :post_created)
	end
end
