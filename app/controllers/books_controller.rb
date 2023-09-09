class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @user = current_user
    @book = Book.new
    # 前提:モデルクラスは単数 それに対応するデータベーステーブルは複数形の命名規則
    # 1. left_joinでbookテーブルをベースに外部結合 いいねがnullでも結合
    # 2. selectで全てのカラムの中のfavoritesテーブルのidの数をカウント 結果をfavorite_countという名前で保存
    # 3. booksテーブルのidでグルーピング いいね複数回されている場合、同じ本が何個も出てくるからこれをしないと一意に定まらない
    @books = Book.left_joins(:favorites)
             .select('books.*, COUNT(favorites.id) AS favorite_count')
             .group('books.id')
             .order('favorite_count DESC')
  end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @user = current_user
      @books = Book.all
      render 'index'
    end
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "You have destroyed book successfully."
  end

  private

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
