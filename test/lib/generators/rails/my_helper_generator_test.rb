require 'test_helper'
require 'generators/rails/my_helper/my_helper_generator'

class Rails::MyHelperGeneratorTest < Rails::Generators::TestCase
  tests Rails::MyHelperGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
