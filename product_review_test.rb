require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_data')

class ProductReview < Test::Unit::TestCase

  def setup
    @product_permalink = TestData.get_product_fixtures["fixture_4"]["url"]
    @selenium = Selenium::WebDriver.for(:firefox)
  end

  def teardown
    @selenium.quit
  end

  def test_add_new_review
    review_form_info = TestData.get_comment_form_values({:name => "Sakaimo"})
    review_id = generate_new_product_review(review_form_info)

    review = find_element(:id, review_id)

    name    = review.find_element(:class, "comment-author-metainfo").find_element(:class, "url").text
    comment = review.find_element(:class, "comment-content").text

    assert_equal("Sakaimo", name)
    assert_equal(review_form_info[:comment], comment)

    parsed_date = DateTime.parse(review.find_element(:class, "comment-author-metainfo").find_element(:class, "commentmetadata").text)
    assert_equal(Date.today.year, parsed_date.year)
    assert_equal(Date.today.month, parsed_date.month)
    assert_equal(Date.today.day, parsed_date.day)
  end

  def test_adding_a_duplicate_review
    review_form_info = TestData.get_comment_form_values
    generate_new_product_review(review_form_info)
    sleep 10
    generate_new_product_review(review_form_info)

    error = find_element(:id, "error-page").text
    assert_equal("Duplicate comment detected; it looks as though you’ve already said that!", error)
  end

  private

  def find_element(how=:css, what)
    @selenium.find_element(how, what)
  end

  def type_text(text, how=:css, what)
    find_element(how, what).clear
    find_element(how, what).send_keys(text)
  end

  def click(how=:css, what)
    find_element(how, what).click
  end

  def select_desired_product_on_homepage(permalink)
    click(:css, ".special-item a[href*='#{permalink}'].more-info")
  end

  def fill_out_comment_form(form_info)
    type_text(form_info[:name], :id, "author")
    type_text(form_info[:email], :id, "email")
    type_text(form_info[:url], :id, "url")
    click(:css, "a[title='5']")
    type_text(form_info[:comment], :id, "comment")
    click(:id, "submit")
  end

  def generate_unique_comment
    "This is a comment for product and is for #{Time.now.to_i}"
  end

  def navigate_to_homepage
    @selenium.get(TestData.get_base_url)
  end

  def get_newly_created_review_id
    @selenium.current_url.split("#").last
  end

  def generate_new_product_review(review)
    navigate_to_homepage
    select_desired_product_on_homepage(@product_permalink)
    fill_out_comment_form(review)
    get_newly_created_review_id
  end
end
