require 'yaml'

class TestData
  def self.get_production_fixtures
    fixture_file = File.join(File.dirname(__FILE__), 'production_fixtures.yml')
    YAML.load_file(fixture_file)
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
