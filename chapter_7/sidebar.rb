Dir[File.join(File.dirname(__FILE__), "./*.rb")].each { |f| require f }

class Sidebar
  def initialize(selenium)
    @selenium = selenium
  end

  def cart
    SidebarCart.new(@selenium)
  end

  def advertisement
  end
end
