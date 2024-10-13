class Menu < ApplicationRecord
  has_many :items, through: :menu_items, dependent: :destroy
end
