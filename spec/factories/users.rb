# == Schema Information
# Schema version: 20140626201417
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  avatar                 :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

FactoryGirl.define do
  factory :user do
    # Ffaker calls need to be in block?! See https://github.com/EmmanuelOga/ffaker/issues/121
    name                  { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              's3cur3p@ssw0rd'
    password_confirmation 's3cur3p@ssw0rd'
    confirmed_at          Time.now

    trait :donald do
      name 'donald'
      email 'donald@example.com'
    end

    trait :with_avatar do
      avatar { File.open dummy_file_path('image.jpg') }
    end

    factory :admin do
      after(:create) do |user|
        user.roles << create(:role, name: 'admin')
      end

      trait :scrooge do
        name  'admin'
        email 'admin@example.com'
      end
    end
  end
end
