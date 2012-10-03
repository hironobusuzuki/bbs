# coding: utf-8
# controller of bbs
class MessagesController < ApplicationController

  # filter
  before_filter :ajax_request?, :only => [ :show ]
  before_filter :delete_message?, :only => [ :destroy ]

  # action
  # display bbs
  # GET /messages
  def index

    @messages = Message.find(:all, :conditions => {:delflg => false}, :order=>"no desc")
    @message = Message.new

  end

  # post a message
  # POST /messages
  def create

    message = Message.new(params[:message])
    message.pwd = Message.fake_encrpt(message.pwd)
    message.sub = Message::NO_SUB if message.sub.blank?
	message.host = request.remote_addr
	message.delflg = false
	message.no = Message.max_no
    message.save

    redirect_to :action => 'index'

  end

  # delete a message
  # DELETE /messages
  def destroy

    Message.transaction do

      # SQLLiteだとfor updateできない→TODO max_noの一意性の確保（未検討）
      message = Message.find(:first, :conditions => {:delflg => false, :no =>params[:message]["no"]}, :lock => true)
      Message.update(message.id, :delflg => true, :no => -1)

      messages = Message.find(:all, :conditions => {:delflg => false}, :order=>"no")
      i = 1
      messages.each do |message|
        message.no = i
        i += 1
	  end

      messages.each do |message|
        Message.update(message.id, :no => message.no)
      end

    end

    redirect_to :action => 'index'

  end

  # reply to a message (Ajax)
  # GET /messages/1
  def show

    @message = Message.find(params[:id])

    render

  end

  # method
  # is request ajax ?
  def ajax_request?

    redirect_to :action => 'index' unless request.xhr?

  end

  # can delte a message ?
  def delete_message?

    no = params[:message]["no"]
    pwd = params[:message]["pwd"]

    # need to fill in delete posted no and pwd
    if no.blank? || pwd.blank?
      logger.info "the no and pwd were not filled in"
      return redirect_to :action => 'index' 
    end

    # don't delete the pwd without settting
    unless Message.set_pwd? no
      logger.info "the pwd wasn't settting"
      return redirect_to :action => 'index'
    end

    # need to the pwd of form  equal to the pwd of model
    unless Message.authenticate(pwd, no)
      logger.info "not authenticated"
      redirect_to :action => 'index'
    end

  end

end
