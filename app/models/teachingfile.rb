class Teachingfile < ApplicationRecord
   mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
   validates_presence_of :filename # Make sure the owner's name is present.

   belongs_to :plans
   belongs_to :materials
end
