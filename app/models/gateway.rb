class Gateway < ActiveRecord::Base
  belongs_to :initiative
  validates :module_name, uniqueness: { scope: :initiative_id }
  store_accessor :settings

  def self.active
    where(active: true)
  end

end
