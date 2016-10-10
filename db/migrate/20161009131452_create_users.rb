class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, unique: true
      t.string :password
      t.string :salt
      t.string :full_name, null: false
      t.date :birthday
      t.text :bio
      t.integer :role, default: User::Type::REGULAR

      t.timestamps null: false
    end

    add_attachment :users, :logo
  end
end
