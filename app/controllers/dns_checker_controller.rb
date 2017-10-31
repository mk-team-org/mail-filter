class DnsCheckerController < ApplicationController
  before_action :set_queries

  def index
  end

  def check
    sq = SearchQuery.new(search_query_params)
    if sq.save
      in_timer = (SearchQuery.where(completed: false).count - 1) * 90
      EmailCheckWorker.perform_in(in_timer.seconds, sq.id)
      flash[:success] = 'Queued'
    else
      flash[:error] = sq.errors.full_messages.to_sentence
    end

    redirect_to dns_checker_index_path
  end

  protected

    def search_query_params
      params.require(:search_query).permit(:first_name, :last_name, :domain, :nip, :company)
    end

    def set_queries
      @sqs = SearchQuery.order('id desc').page(params[:page])
    end
end
