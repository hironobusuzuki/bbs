# coding: utf-8
require 'digest'
# model of bbs's message
class Message < ActiveRecord::Base

  # accessor
  attr_accessible :comment, :delflg, :email, :host, :name, :pwd, :sub, :no

  # validator
  # TODO transrate error message
  validates :name, :presence => { :message =>"は必須です。"}
  validates :comment, :presence => { :message =>"は必須です。"}
  validates :email, :presence => { :message =>"は必須です。"},
                    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  # constant
  NO_SUB = "無題"

  # pagenator default
  default_scope :order => 'no desc'
  paginates_per 5

  # method
  # get maximum posted no
  def self.max_no

    message = 0

    Message.transaction do

      # SQLLiteだとfor updateできない→TODO max_noの一意性の確保（未検討）
      message = Message.find(:first, :conditions => {:delflg => false}, :order=>"no desc", :lock => true)

    end

    message.no + 1

  end

  # fake encrpt value
  def self.fake_encrpt(value)

    Digest::SHA256.base64digest(value)

  end

  # authenticate
  def self.authenticate(del_pwd, del_no)

    message = Message.find(:first, :conditions => {:delflg => false, :no =>del_no, :pwd=>fake_encrpt(del_pwd)}, :lock => true)
    message.present?

  end

  # is setting pwd
  def self.set_pwd?(del_no)

    message = Message.find(:first, :conditions => {:delflg => false, :no =>del_no}, :lock => true)
    (message.blank? || message.pwd.blank?) ? false : true

  end

end
