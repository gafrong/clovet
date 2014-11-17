parsed = JSON.parse(File.read("db/the_iconic_data_feed.json"))

Item.destroy_all
Category.destroy_all
# please delete when we have a working app
User.destroy_all


User.create(:name => 'jam', :email => 'jam@jam.com', :password => 'jam', :password_confirmation => 'jam')

parsed.each do |item|

  new_item = Item.new
  new_item.merchant_id = item["MerchantId"]
  new_item.sku = item["SKU"]
  new_item.name = item["Name"]
  new_item.merchant_url = item["Url"]
  new_item.price = item["Price"]
  new_item.price_sale = item["PriceSale"]
  new_item.brand = item["Brand"]
  new_item.color = item["Colour"]
  new_item.gender = item["Gender"]
  new_item.keywords = item["Keywords"]
  new_item.image_url50 = item["Image50"]
  new_item.image_url400 = item["Image400"]
  new_item.active = true

  category_s = item["Category"]
  categories_array = category_s.split(' > ')
  parent_id = nil
  categories_array.each do |category|
    if Category.where(:child => category).length > 0
      existing = Category.where(:child => category)
      parent_id = existing.first.id
    else
      new_category = Category.create(:child => category, :parent_id => parent_id)
      parent_id = new_category.id
    end
  end

  new_item.category_id = parent_id
  new_item.save

end