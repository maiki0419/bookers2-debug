class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]
  before_action :ensure_guest_user, only: [:edit]


  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @category = @book.categories.new
    @currentuserentry = Entry.where(user_id: current_user.id)
    @userentry = Entry.where(user_id: @user.id)



    if @user.id != current_user.id

      @currentuserentry.each do |cu|
        @userentry.each do |u|

          if cu.room_id == u.room_id
            @isroom = true
            @roomid = cu.room_id
          end

        end
      end

      unless @isroom
        @room = Room.new
        @entry = Entry.new
      end

   end




    #bookrecord7b@record_today = @books.created_today
    #bookrecord7b@record_yesterday = @books.created_yesterday
    #bookrecord7b@record_day = @record_today.count / @record_yesterday.count.to_f
    #bookrecord7b@record_thisweek = @books.created_thisweek
    #bookrecord7b@record_lastweek = @books.created_lastweek
    #bookrecord7b@record_week = @record_thisweek.count / @record_lastweek.count.to_f

    #bookrecord8b@record_today = @books.created_today
    #bookrecord8b@record_1day = @books.created_1day
    #bookrecord8b@record_2day = @books.created_2day
    #bookrecord8b@record_3day = @books.created_3day
    #bookrecord8b@record_4day = @books.created_4day
    #bookrecord8b@record_5day = @books.created_5day
    #bookrecord8b@record_6day = @books.created_6day

    day =params[:day]
    @record_search = @books.where(['created_at LIKE ? ', "#{day}%"])

  end

  def index
    @users = User.all
    @book = Book.new
    @category = @book.categories.new
  end

  def followings
    user = User.find(params[:id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  def edit
    @user = User.find(params[:id])
  end


  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user),notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
