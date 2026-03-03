class BooksQuery
  ALLOWED_SORT_COLUMNS = %w[title created_at average_rating].freeze

  def initialize(params, scope = Book.all)
    @params = params
    @scope = scope
  end

  def call
    scope = @scope.includes(reviews: :user)
    scope = search(scope)
    scope = sort(scope)
    scope = paginate(scope)
    scope
  end

  private

  def search(scope)
    return scope unless @params[:search].present?

    scope.search_by_title_and_author(@params[:search])
  end

  def sort(scope)
    sort_by = ALLOWED_SORT_COLUMNS.include?(@params[:sortBy]) ? @params[:sortBy] : "created_at"
    order = @params[:order] == "desc" ? :desc : :asc

    scope.order(sort_by => order)
  end

  def paginate(scope)
    page = [@params[:page].to_i, 1].max
    per_page = @params[:per_page].present? ? @params[:per_page].to_i : 10
    per_page = [[per_page, 1].max, 50].min

    scope.limit(per_page).offset((page - 1) * per_page)
  end
end
