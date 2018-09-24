class Ttopic < ApplicationRecord
  belongs_to :subject, optional: true
end
