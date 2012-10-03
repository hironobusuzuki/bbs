require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  #test "the truth" do
  #  assert true
  #end

  def test_max_no
  	max_no = Message.max_no
    assert_equal 3, max_no
  end

end
