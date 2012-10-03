# coding: utf-8
require 'digest'
# model of bbs's message
class Message < ActiveRecord::Base

  # accessor
  attr_accessible :comment, :delflg, :email, :host, :name, :pwd, :sub, :no

  # validator
  validates :name, :presence => true
  validates :comment, :presence => true
  validates :email, :presence => true,
                    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  # constant
  NO_SUB = "無題"

  # method
  # get maximum posted no
  def self.max_no

    message = 0

    Message.transaction do

      # SQLLiteだとfor updateできない→TODO max_noの一意性の確保（未検討）
      message = Message.find(:first, :conditions => {:delflg => false}, :order=>"no desc", :lock => true)

    end

    return message.no + 1

  end

  # fake encrpt value
  def self.fake_encrpt(value)

    Digest::SHA256.base64digest(value)

  end

  # authenticate
  def self.authenticate(del_pwd, del_no)

    message = Message.find(:first, :conditions => {:delflg => false, :no =>del_no, :pwd=>fake_encrpt(del_pwd)}, :lock => true)
    message.present? ? true : false

  end

  # is setting pwd
  def self.set_pwd?(del_no)

    message = Message.find(:first, :conditions => {:delflg => false, :no =>del_no}, :lock => true)
    message.present? ? true : false

  end

end
