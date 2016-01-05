Dir[File.join(File.dirname(__FILE__), "./*.rb")].each { |f| require f }

class AAA
  def name
    "aaa"
  end

  b = BBB.new
  puts name + b.age
end
