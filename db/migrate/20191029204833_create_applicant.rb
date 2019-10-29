class CreateApplicant < ActiveRecord::Migration
  def change
    create_table :applicant do |t|
      t.string :name
      t.string :applicant_id
      t.string :tests
      t.string :pii
      t.string :contact
      t.string :company_id
      # t.int :supervisor_id
    end
  end
end
