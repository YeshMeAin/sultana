class MenuItem < ApplicationRecord
  enum units: {
    kilograms: 0,
    liters: 1,
    pieces: 2,
  }
end
