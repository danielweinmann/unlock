class UpdateAllContributionsState < ActiveRecord::Migration
  def change
    execute("UPDATE contributions SET state = 0")
  end
end
