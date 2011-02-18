require 'test_helper'

class TabTest < ActiveSupport::TestCase
  
  setup do
  	@page = Page.create(:slug => "home1")
  end
  
  teardown do
    Tab.all.each do |tab|
      tab.delete_descendants
      tab.destroy
    end
    
    Page.all.each do |page|
    	page.destroy
    end
  end
  
  test "create a normal tab" do
    tab1 = Tab.new(:slug => "home", :name => "home", :description => "The home tab which will be used for link to the home page")
    tab1.page = @page
    assert tab1.valid?, tab1.errors.full_messages.map { |msg| msg + ".\n" }.join
    tab1.save
    
    tab2 = Tab.new(:slug => "about", :name => "About")
    tab2.page = @page
    tab2.save
    
    tab3 = tab2.children.new(:slug => "ci", :name => "Company Info")
    tab3.page = @page
    tab3.save
    assert_equal tab2, tab3.parent
    
    tab4 = tab3.children.new(:slug => "it", :name => "IT Depertment")
    tab4.page = @page
    tab4.save
    tab5 = tab3.children.new(:slug => "sd", :name => "Software Department", :hidden => true)
    tab5.page = @page
    tab5.save
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
    tab = Tab.new(:slug => "home", :name => "Home")
    tab.page = page
    tab.save
    
    assert_equal page, tab.page
  end
end
