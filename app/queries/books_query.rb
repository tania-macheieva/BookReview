class BooksQuery
  def initialize(params, scope = Book.all)
    @params = params
    @scope = scope
  end

  def call
    @scope.includes(reviews: :user)
          .yield_self(&method(:search))
          .yield_self(&method(:sort))
          .yield_self(&method(:paginate))
  end

  private

  def search(scope)
    return scope unless @params[:search].present?
    scope.search_by_title_and_author(@params[:search])
  end

  def sort(scope)
    sort_column = %w[title created_at average_rating].include?(@params[:sort_by]) ? @params[:sort_by] : "created_at"
    sort_direction = @params[:order] == "desc" ? "desc" : "asc"
    scope.order(sort_column => sort_direction)
  end

  def paginate(scope)
    page = [@params[:page].to_i, 1].max
    per  = @params[:per_page].present? ? @params[:per_page].to_i : 10
    per = [[per, 1].max, 50].min  # мін 1, макс 50
    scope.limit(per).offset((page - 1) * per)
  end
end
