class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :name
      t.string :applicant_id
      t.string :pii
      t.string :contact
      t.string :company_id
      # t.string :tests
      # t.integer :supervisor_id
    end
  end
end
