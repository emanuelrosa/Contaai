class StoriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]


  def index

    @stories = Story.all.order(created_at: :desc).page(params[:page]).per(5)
    # Verifica se o usuário entrou com keywords
  if params[:keywords].present?
    # Diz ao elastickick para pesquisar as keyrwords nos campos name e description
    @stories = Story.search params[:keywords], fields: [:title, :body]
  end
  end

  def new
    @story = Story.new
  end


  def create
    @story = Story.new(story_params)
    @story.user = current_user
    if @story.save
      redirect_to @story
    else
      flash[:danger] = @story.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @story = Story.find(params[:id])
  end

  def upvote
    @story = Story.find(params[:id])
    @story.upvote_by(current_user)
    redirect_to :back
  end

  def downvote
    @story = Story.find(params[:id])
    @story.downvote_by(current_user)
    redirect_to :back
  end



  private

  def story_params
    params.require(:story).permit(:body, :title)
  end


end
