class CreateCompany < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :ein
      t.string :company_id
      t.string :tests
      # t.string :employee
      t.string :contact_info
      t.string :applicant
    end
  end
end
