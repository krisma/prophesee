class PostsController < ApplicationController
	before_action :authenticate_user!
	def create
		@post = current_user.posts.new(create_post_params)
		if @post.save
			flash[:notice] = "Post created!"
		else
			if @post.errors.any?
				flash[:error] ||= []
				@post.errors.full_messages.each do |value|
					flash[:error] << value
				end
			end
		end
		redirect_to root_path
    end
  

	private
	def create_post_params
		params.require(:post).permit(:content, :date_publish, :post_created)
	end
end
