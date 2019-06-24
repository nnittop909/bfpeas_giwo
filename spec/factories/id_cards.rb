FactoryBot.define do
  factory :id_card do
    id_number { "MyString" }
    rfid_uid { "MyString" }
    active { false }
    employee { nil }
  end
end
