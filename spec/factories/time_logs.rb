FactoryBot.define do
  factory :time_log do
    logged_at { "2019-06-04 08:58:24" }
    status { 1 }
    employee { nil }
  end
end
