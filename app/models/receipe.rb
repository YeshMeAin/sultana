class Receipe < ApplicationRecord
  belongs_to :product
  belongs_to :item
end
