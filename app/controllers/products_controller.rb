class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:index]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    response.headers['Access-Control-Allow-Origin']='*'
    response.headers['Access-Control-Allow-Methods']='GET,POST'
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }

        @products = Product.all
        #发送广播 当频道订阅者使用流接收某个广播时，发布者发布的内容会被直接发送给订阅者。
        ActionCable.server.broadcast 'products',
        html: render_to_string('store/index',layout: false)
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @lastest_order = @product.orders.order(:updated_at).last
    if stale?(@lastest_order)
      respond_to do |format|
        format.atom
        format.html 
        format.xml {render :xml => @product.to_xml(include: :orders)}
        format.json {render :json => @product.to_json(include: :orders)}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      #Ruby on Rails 内置了针对特殊 SQL 字符的过滤器，用于转义 '、"、NULL 和换行符。当我们使用 Model.find(id) 和 Model.find_by_something(something) 方法时，Rails 会自动应用这个过滤器。但在 SQL 片段中，尤其是在条件片段（where("…​")）中，需要为 connection.execute() 和 Model.find_by_sql() 方法手动应用这个过滤器
      @product = Product.find(params[:id])
      #为了净化受污染的字符串，在提供查询条件的选项时，我们应该传入数组而不是直接传入字符串：

      # Model.where("login = ? AND password = ?", entered_user_name, entered_password).first
      # 如上所示，数组的第一个元素是包含问号的 SQL 片段，从第二个元素开始都是需要净化的变量，净化后的变量值将用于代替 SQL 片段中的问号。我们也可以传入散列来实现相同效果：

      # Model.where(login: entered_user_name, password: entered_password).first
      # 只有在模型实例上，才能通过数组或散列指定查询条件。对于其他情况，我们可以使用 sanitize_sql() 方法。遇到需要在 SQL 中使用外部字符串的情况时，请养成考虑安全问题的习惯。
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end
end
