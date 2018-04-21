require 'test_helper'

class Resolvers::CreateLinkTest < ActiveSupport::TestCase
  def perform(args={})
    Resolvers::CreateLink.new.call(nil, args, {})
  end

  test 'creating new link' do
    link = perform(
      url: 'http://mintdigital.com',
      description: 'description'
    )

    assert link.persisted?
    assert_equal link.description, 'description'
    assert_equal link.url, 'http://mintdigital.com'
  end
end
