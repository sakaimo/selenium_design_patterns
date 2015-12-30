require 'yaml'
require 'net/http'
require 'json'

class TestData

  def self.get_product_fixtures
    fixture_file = File.join(File.dirname(__FILE__), 'product_fixtures.yml')
    YAML.load_file(fixture_file)
  end

  def self.get_products_from_api
    uri = URI.parse("http://api.awful-valentine.com/")
    json_string = Net::HTTP.get(uri)
    JSON.parse(json_string)
  end

  def self.get_base_url
    {
      "production" => "http://awful-valentine.com/",
      "staging"    => "http://stating.awful-valentine.com/",
      "test"       => "http://test.awful-valentine.com/"
    }[self.get_environment]
  end

  def self.get_environment
    ENV['environment'] || "test"
  end
end
