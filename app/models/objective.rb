class Objective < ActiveRecord::Base
  belongs_to :metric
  has_many :events
end
