require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'

class ProductReview < Test::Unit::TestCase
  def test_add_new_review
    selenium = Selenium::WebDriver.for(:firefox)
    selenium.get("http://awful-valentine.com/")

    selenium.find_element(:css, '.special-item a[href*="our-love-is-special"].more-info').click
    assert_equal("http://awful-valentine.com/our-love-is-special/", selenium.current_url)
    assert_equal("Our love is special!", selenium.find_element(:css, ".category-title").text)

    selenium.find_element(:id, "author").send_keys("Sakaimo")
    selenium.find_element(:id, "email").send_keys("sakaimo@selenium.com")
    selenium.find_element(:id, "url").send_keys("http://awful-valentine.com")
    selenium.find_element(:css, "a[title='5']").click
    selenium.find_element(:id, "comment").clear
    selenium.find_element(:id, "comment").send_keys("3 This is a comment for product. #{ENV['USERNAME'] || ENV['USER']}")
    selenium.find_element(:id, "submit").click

    review_id = selenium.current_url.split("#").last
    review    = selenium.find_element(:id, review_id)

    name    = review.find_element(:class, "comment-author-metainfo").find_element(:class, "url").text
    comment = review.find_element(:class, "comment-content").text

    assert_equal("Sakaimo", name)
    assert_equal("3 This is a comment for product. #{ENV['USERNAME'] || ENV['USER']}", comment)

    parsed_date = DateTime.parse(review.find_element(:class, "comment-author-metainfo").find_element(:class, "commentmetadata").text)
    assert_equal(Date.today.year, parsed_date.year)
    assert_equal(Date.today.month, parsed_date.month)
    assert_equal(Date.today.day, parsed_date.day)

    selenium.quit
  end

  def test_adding_a_duplicate_review
    selenium = Selenium::WebDriver.for(:firefox)
    selenium.get("http://awful-valentine.com/")

    selenium.find_element(:css, '.special-item a[href*="our-love-is-special"].more-info').click

    selenium.find_element(:id, "author").send_keys("Sakaimo")
    selenium.find_element(:id, "email").send_keys("sakaimo@selenium.com")
    selenium.find_element(:id, "url").send_keys("http://awful-valentine.com")
    selenium.find_element(:css, "a[title='5']").click
    selenium.find_element(:id, "comment").clear
    selenium.find_element(:id, "comment").send_keys("3 This is a comment for product. #{ENV['USERNAME'] || ENV['USER']}")
    selenium.find_element(:id, "submit").click

    error = selenium.find_element(:id, "error-page").text
    assert_equal("Duplicate comment detected; it looks as though you’ve already said that!", error)

    selenium.quit
  end
end
