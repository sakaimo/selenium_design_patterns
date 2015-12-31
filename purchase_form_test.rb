require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_data')
I18n.enforce_available_locales = false

class PurchaseFormTests < Test::Unit::TestCase
  def setup
    @selenium = Selenium::WebDriver.for(:firefox)
  end

  def teardown
    @selenium.quit
  end

  def test_fillout_purchase_form
    @selenium.get(TestData.get_base_url + "/purchase-forms/perfect-world")

    type_text(TestData.get_full_name, :id, "name")
    type_text(TestData.get_credit_card_number, :id, "cc")
    type_text(TestData.get_credit_card_expiry_date.month, :id, "month")
    type_text(TestData.get_credit_card_expiry_date.year, :id, "year")

    click(:id, "go")

    assert_equal("Purchase complete!", get_inner_text(:id, "success"))
  end

  private

  def find_element(how=:css, what)
    @selenium.find_element(how, what)
  end

  def type_text(text, how=:css, what)
    find_element(how, what).send_keys(text)
  end

  def click(how=:css, what)
    find_element(how, what).click
  end

  def get_inner_text(how=:css, what)
    find_element(how, what).text
  end
end
