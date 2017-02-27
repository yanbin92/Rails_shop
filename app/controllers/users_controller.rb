class UsersController < ApplicationController
  skip_before_action :authorize,only: [:new,:create] #if User.count === 0
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  layout "users", only: [:page1]
  layout "application", except: [:page1]
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def page1
    # respond_to do |format|
   #        format.html #page1.html.erb
   #    end
  end

  # GET /users/new
  def new

    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)
    # byebug
    respond_to do |format|
      if @user.save
          # byebug
        format.html { redirect_to users_url, notice: 'User #{@user.name} was uccessfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, 
          notice: 'User #{@user.name} was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
        @user.destroy
    rescue Exception => e
      redirect_to users_url, notice: e.message
      return
    end

    respond_to do |format|
      format.html { redirect_to users_url,
       notice: 'User  #{@user.name} was successfully destroyed.' }
      format.json { head :no_content }
    end
  end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

  
  #layout :dynamic_choose_layout

  #def dynamic_choose_layout
  #  @name.exit? ? "xx layout":"";
 # end
 #条件布局
#在控制器中指定布局时可以使用 :only 和 :except 选项。这两个选项的值可以是一个方法名或者一个方法名数组，这些方法都是控制器中的动作：

#class ProductsController < ApplicationController
 # layout "product", except: [:index, :rss]
#end
#这么声明后，除了 rss 和 index 动作之外，其他动作都使用 product 布局渲染视图。

# 布局继承

#布局声明按层级顺序向下顺延，专用布局比通用布局优先级高

end
