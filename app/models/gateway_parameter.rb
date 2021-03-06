class GatewayParameter < ActiveRecord::Base
  CLASS_TYPES = ['String', 'Integer', 'Boolean']

  attr_accessible :gateway_id, :name, :value, :class_type, :description

  belongs_to :gateway, :touch => true

  validates :name,
            :presence => true,
            :uniqueness => {:scope => :gateway_id}

  validates :class_type,
            :presence => true,
            :inclusion => { :in => CLASS_TYPES }

  def to_s
  	name
  end
end
