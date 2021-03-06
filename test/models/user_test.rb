require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "Ex user", email: "user@ex.com",
						password: "foobar", password_confirmation: "foobar")
	end
	
	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = "   "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "  "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email validation should reject invalid addresses" do
		invalid_addr = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
		invalid_addr.each do |i|
			@user.email = i
			assert_not @user.valid?, "#{i.inspect} should be valid"
		end
	end

	test "email address should be unique" do 
		dup_user = @user.dup
		dup_user.email = @user.email.upcase
		@user.save
		assert_not dup_user.valid?
	end

	test "email addresses should be saved in lower case" do 
		mixed_case_email = "Foo@ExaMple.Com"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test "password should be present (nonblank)" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end
end
