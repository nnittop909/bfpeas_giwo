# frozen_string_literal: true

class DeviseCreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :full_name
      t.string :alternate_email
      t.string :designation
      t.date   :birthdate
      t.integer :marital_status
      t.string  :spouse_name
      t.integer :role
      t.string :default_key

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      t.belongs_to :school,     foreign_key: true, type: :uuid
      t.belongs_to :department, foreign_key: true, type: :uuid

      t.timestamps null: false
    end

    add_index :employees, :email,                unique: true
    add_index :employees, :reset_password_token, unique: true
    # add_index :employees, :confirmation_token,   unique: true
    # add_index :employees, :unlock_token,         unique: true
  end
end
