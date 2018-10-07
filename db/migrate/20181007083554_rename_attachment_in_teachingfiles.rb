class RenameAttachmentInTeachingfiles < ActiveRecord::Migration[5.1]
  def change
    rename_column :teachingfiles, :attachment, :attachments
  end
end
