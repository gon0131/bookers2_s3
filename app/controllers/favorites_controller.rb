class FavoritesController < ApplicationController
  def create
    # if !Favorite.find(book_id: params[:book_id], user_id: current_user.id).exists?
      @book = Book.find(params[:book_id])
      # @books = Book.find(Favorite.group(:book_id).order('count(book_id) desc').pluck(:book_id))
      # @books = Book.left_joins(:favorites)
            # .select('books.*, COUNT(favorites.id) AS favorite_count')
            # .group('books.id')
            # .order('favorite_count DESC')

      @favorite = current_user.favorites.new(book_id: @book.id)
      @favorite.save
      render "replace_btn"
    # end
  end

  def destroy
    # if Favorite.find(book_id: params[:book_id], user_id: current_user.id).exists?
      @book = Book.find(params[:book_id])
      # @books = Book.find(Favorite.group(:book_id).order('count(book_id) desc').pluck(:book_id))
      # @books = Book.left_joins(:favorites)
      #       .select('books.*, COUNT(favorites.id) AS favorite_count')
      #       .group('books.id')
      #       .order('favorite_count DESC')
      @favorite = current_user.favorites.find_by(book_id: @book.id)
      @favorite.destroy
      render "replace_btn"
    # end
  end
end
