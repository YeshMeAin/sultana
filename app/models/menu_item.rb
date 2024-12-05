class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item

  def self.currently_displayed
    joins(:menu, :item).where(menu: { currently_displayed: true })
  end
end
