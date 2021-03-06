class Switchboard < ActiveRecord::Base
  # https://github.com/rails/strong_parameters
  include ActiveModel::ForbiddenAttributesProtection

  validates :name,
            :presence => true,
            :uniqueness => {:scope => :user_id}

  validates :reload_interval,
            :numericality => { :only_integer => true, 
                               :greater_than => 249,
                               :allow_nil => true 
                             }

  validates :entry_width,
            :numericality => { :only_integer => true, 
                               :greater_than => 0,
                               :less_than => 5
                             }

  validates :amount_of_displayed_phone_numbers,
            :numericality => { :only_integer => true, 
                               :greater_than_or_equal_to => 0,
                               :less_than => 20
                             }

  belongs_to :user, :touch => true
  has_many :switchboard_entries, :dependent => :destroy
  has_many :sip_accounts, :through => :switchboard_entries
  has_many :phone_numbers, :through => :sip_accounts

  before_validation :convert_0_to_nil

  def to_s
    self.name.to_s
  end

  def active_calls
    self.switchboard_entries.where(:switchable => true).map{|se| se.sip_account}.uniq.map{|sip_account| sip_account.calls}.flatten
  end

  private
  def convert_0_to_nil
    if self.reload_interval == 0
      self.reload_interval = nil
    end
  end
end
