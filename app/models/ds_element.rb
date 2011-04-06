class DsElement
  include Mongoid::Document
  
  field :key
  field :name
  field :ftype, :default => "String"
  field :unique, :type => Boolean, :default => false
  field :notnull, :type => Boolean, :default => false
  field :multi_lang, :type => Boolean, :default => false
  
  referenced_in :image_style
  embedded_in :d
  
  validates_presence_of :key
  validates_presence_of :name
  validates_uniqueness_of :key
  validates_format_of :key, :with => /\A([A-Za-z][\w]+)\z/
end
