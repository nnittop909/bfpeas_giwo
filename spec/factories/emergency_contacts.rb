FactoryBot.define do
  factory :emergency_contact do
    first_name { "MyString" }
    middle_name { "MyString" }
    last_name { "MyString" }
    relationship { "MyString" }
    employee { nil }
  end
end
