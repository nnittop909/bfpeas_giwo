FactoryBot.define do
  factory :schedule do
    name { "MyString" }
    shift_type { 1 }
    starts_at { "2019-05-23 21:31:39" }
    ends_at { "2019-05-23 21:31:39" }
    employee { nil }
  end
end
