class SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    @model=params[:model]
    # contentは_search.html.erbのformで入力した値
    @content=params[:content]
    @method=params[:method]
    if @model == 'user'
      @records=User.search_for(@content,@method)
    else
      @records=Book.search_for(@content,@method)
    end
  end
end
