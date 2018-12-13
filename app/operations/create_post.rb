# frozen_string_literal: true

class CreatePost < BaseOperation
  validates_presence_of :title, :content, :login, :ip

  def run
    user = User.find_or_create_by!(login: params[:login])
    ip = Ip.find_or_create_by!(ip: params[:ip])

    ip.with_lock do
      post = Post.create!(
        title: params[:title],
        content: params[:content],
        user_id: user.id,
        ip_id: ip.id
      )

      ip.add_user_login!(params[:login])

      post
    end
  end
end
