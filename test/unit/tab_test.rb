require 'test_helper'

class TabTest < ActiveSupport::TestCase
  
  setup do
    Tab.all.each do |tab|
      tab.delete_descendants
      tab.destroy
    end
  end
  
  test "create a normal tab" do
    tab1 = Tab.new(:name => "home", :description => "The home tab which will be used for link to the home page")
    assert tab1.valid?
    tab1.save
    
    tab2 = Tab.new(:name => "About")
    tab2.save
    
    tab3 = tab2.children.create(:name => "Company Info")
    assert_equal tab2, tab3.parent
    
    tab4 = tab3.children.create(:name => "IT Depertment")
    tab5 = tab3.children.create(:name => "Software Department", :hidden => true)
    assert_not_nil tab4.ancestors.map{|x| x.id}.find_index(tab3.id)
    assert_not_nil tab4.ancestors.map{|x| x.id}.find_index(tab2.id)
    assert_nil tab4.ancestors.map{|x| x.id}.find_index(tab1.id)
    assert tab5.hidden?
    assert !tab4.hidden?
    
    assert_not_nil tab4.lower_siblings.map{|x| x.id}.find_index(tab5.id)
    
    assert_not_nil Tab.roots.map{|x| x.id}.find_index(tab1.id)
    assert_not_nil Tab.roots.map{|x| x.id}.find_index(tab2.id)
  end
  
  test "a tab referenced to a page" do
    page = Page.create(:slug => "home", :title => "Home")
    tab = Tab.create(:name => "Home")
    tab.page = page
    tab.save
    
    assert_equal page, tab.page
    assert_equal tab, page.tab
  end
end