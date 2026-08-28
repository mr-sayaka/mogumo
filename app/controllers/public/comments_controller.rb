class Admin::CommentsController < Admin::BaseController
  before_action :require_authentication
  before_action :set_post
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_comment!, only: [:update, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = Current.user

    if @comment.save
      redirect_to public_post_path(@post),
                  notice: "コメントを投稿しました。"
    else
      redirect_to public_post_path(@post),
                  alert: @comment.errors.full_messages.to_sentence
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to public_post_path(@post),
                  notice: "コメントを編集しました。"
    else
      redirect_to public_post_path(@post),
                  alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @comment.destroy

    redirect_to public_post_path(@post),
                notice: "コメントを削除しました。"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_comment!
    unless @comment.user == Current.user
      redirect_to public_post_path(@post),
                  alert: "このコメントを編集・削除する権限がありません。"
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end