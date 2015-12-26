require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'

class CheeseFinderTests < Test::Unit::TestCase

  def test_find_some_cheese
    selenium = Selenium::WebDriver.for(:firefox)
    selenium.get("http://awful-valentine.com/")
    elem = selenium.find_element(:id, "searchinput")
    elem.clear
    elem.send_keys("cheese")
    selenium.find_element(:id, "searchsubmit").click

    selenium.quit
  end
end
