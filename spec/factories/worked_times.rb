FactoryBot.define do
  factory :worked_time do
    date { "2019-06-04" }
    in_at { "2019-06-04 09:02:28" }
    out_at { "2019-06-04 09:02:28" }
    duration { 1 }
    employee { nil }
  end
end
