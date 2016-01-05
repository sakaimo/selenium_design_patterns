class SpecialItems
  def initialize(selenium)
    @selenium = selenium
    @special_items = get_special_items
    puts "special_itemコンストラクタ＝" + @special_items
  end

  def get_special_items
    @selenium.find_elements(:class, "special-item").collect do |element|
      @special_items.push(element)
    end
  end

  def find(title)
    puts "findきた"
    @special_items.each do |item|
      puts "title:" + item.find_element(:class, "title").text
    end
  end
end
