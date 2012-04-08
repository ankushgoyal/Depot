require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  test "Product is not valid without unique title" do
    product = Product.new(:title => products(:ruby).title,
                :description => "bla",
                :price => 19.57,
                :image_url => "abc.jpg")
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end

  test "Product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
     assert product.errors[:image_url].any?
  end

  test "Product price must be positive" do
    product = Product.new(:title => "My book",
                          :description => "description",
                          :image_url => "xyz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end

  def new_product(name)
    Product.new(:title => "My book",
                :description => "description",
                :price => 1,
                :image_url => name)
  end

  test "Product image url should be a jpg|gif|png" do
    ok = %w{xyz.gif abc.jpg ankg.png http://a.b.c/x/y/z/ank.jpg}
    bad = %w{abc.more ank.MORE more.jpeg}

    ok.each do |name|
      assert new_product(name).valid? "#{name} shouldn't be invalid."
    end

    bad.each do |name|
      assert new_product(name).invalid? "#{name} shouldn't be valid."
    end
  end
end
