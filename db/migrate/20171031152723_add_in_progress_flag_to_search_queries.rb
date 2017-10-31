class AddInProgressFlagToSearchQueries < ActiveRecord::Migration[5.0]
  def change
    add_column :search_queries, :in_progress, :boolean, default: false
  end
end
