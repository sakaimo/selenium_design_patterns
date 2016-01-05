Dir[File.join(File.dirname(__FILE__), "./*.rb")].each { |f| require f }

#include Header
#include Sidebar
#include Body
#include Footer

class ContactUsPage < Page
  def page_path
    "/contact-us/"
  end
end
