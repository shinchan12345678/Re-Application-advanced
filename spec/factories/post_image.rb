FactoryBot.define do
  factory :post_image do
    shop_name {'test'}
    caption {'test_ca'}
    user
    after(:build) do |post_image|
      post_image.image.attach(io: File.open('spec/fixture/test_image.jpg'),filename: 'test_image.jpg',content_type: 'image/jpg')
    end
  end
end