class Company < ActiveRecord::Base
  has_many :applicants
end