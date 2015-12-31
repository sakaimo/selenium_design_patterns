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
    @selenium.get(TestData.get_base_url + "/purchase-forms/slow-animation")

    type_text(TestData.get_full_name, :id, "name")
    type_text(TestData.get_credit_card_number, :id, "cc")
    type_text(TestData.get_credit_card_expiry_date.month, :id, "month")
    type_text(TestData.get_credit_card_expiry_date.year, :id, "year")

    wait_for_animation
    click(:id, "go")
    wait_for_ajax
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

  def wait_for_ajax
    Selenium::WebDriver::Wait.new(:timeout => 60).until do
      sleep 1
      @selenium.execute_script("return jQuery.active") == 0
    end
  end

  def wait_for_animation
    Selenium::WebDriver::Wait.new(:timeout => 60).until do
      sleep 1
      @selenium.execute_script("return jQuery(':animated').length") == 0
    end
  end
end
