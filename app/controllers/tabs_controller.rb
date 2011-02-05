class TabsController < ApplicationController
  theme "wow"
  # GET /tabs
  # GET /tabs.xml
  def index
    @tabs = Tab.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tabs }
    end
  end

  # GET /tabs/1
  # GET /tabs/1.xml
  def show
    @tab = Tab.find(:first, :conditions => {:slug => params[:id]}) || Tab.find(params[:id])
    begin
      @page = @tab.page

      ds = @page.ds
      begin
        template_content = IO.read(File.join(theme_path, "theme", @page.theme_path ))
      rescue
        template_content = IO.read(File.join(theme_path, "theme", "page_default.html" ))
      end
      template = Liquid::Template.parse(template_content)  # Parses and compiles the template
      #TODO need to cache the template somewhere in future

      #Assemble the variable and it's content, and then pass to template
      render_params = Hash.new
      render_params[:params] = params
      if ds
        for d in ds
          render_params[d.key] = d.get_klass.all
        end
      end

      respond_to do |format|
        format.html { render :layout => "front", :text => template.send(:render, render_params)}
        format.xml  { render :xml => @page }
      end
    rescue BSON::InvalidObjectId => e
      render :text => "page not found"
    end
  end

  # GET /tabs/new
  # GET /tabs/new.xml
  def new
    @tab = Tab.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tab }
    end
  end

  # GET /tabs/1/edit
  def edit
    @tab = Tab.find(:first, :conditions => {:slug => params[:id]}) || Tab.find(params[:id])
  end

  # POST /tabs
  # POST /tabs.xml
  def create
    @tab = Tab.new(params[:tab])
    if params[:tab][:page]
      @page = Page.find(params[:tab][:page])
      @tab.page = @page
    end

    respond_to do |format|
      if @tab.save
        format.html { redirect_to(@tab, :notice => 'Tab was successfully created.') }
        format.xml  { render :xml => @tab, :status => :created, :location => @tab }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tabs/1
  # PUT /tabs/1.xml
  def update
    @tab = Tab.find(:first, :conditions => {:slug => params[:id]}) || Tab.find(params[:id])

    respond_to do |format|
      if @tab.update_attributes(params[:tab])
        format.html { redirect_to(@tab, :notice => 'Tab was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tabs/1
  # DELETE /tabs/1.xml
  def destroy
    @tab = Tab.find(:first, :conditions => {:slug => params[:id]}) || Tab.find(params[:id])
    @tab.destroy

    respond_to do |format|
      format.html { redirect_to(tabs_url) }
      format.xml  { head :ok }
    end
  end
end
