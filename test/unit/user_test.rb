require 'test_helper'

class UserTest < ActiveSupport::TestCase
	should have_many(:user_friendships)
	should have_many(:friends)
	should have_many(:pending_friends)
	should have_many(:pending_user_friendships)
	should have_many(:requested_friends)
	should have_many(:requested_user_friendships)
	should have_many(:blocked_friends)
	should have_many(:blocked_user_friendships)

	test "a user should enter a first name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a user should enter a last name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end
	test "a user should have a unique profile name" do 
		user = User.new
		user.profile_name = users(:arkadiusz).profile_name
		
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a profile name without spaces" do 
		user = User.new(first_name: 'Janusz', last_name: 'kowalski', email: 'arek@arek.com')
		user.password = user.password_confirmation = 'asdfasdf'
		user. profile_name = "My profile with spaces"

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?("Must be formatted correctly")
	end

	test "a user can have a correct profile name" do
		user = User.new(first_name: 'Janusz', last_name: 'kowalski', email: 'arek@arek.com')
		user.password = user.password_confirmation = 'asdfasdf'

		user.profile_name = 'arkadiusz_1'
		assert user.valid?
	end

	test "that no error is raised when trying to use friends list" do 
		assert_nothing_raised do 
			users(:arkadiusz).friends
		end
	end

	test "that creating friendships on a user works" do 
		users(:arkadiusz).pending_friends << users(:mike)
		users(:arkadiusz).pending_friends.reload
		assert users(:arkadiusz).pending_friends.include?(users(:mike))
	end

	test "that calling to_param on a user returns the profile_name" do 
		assert_equal "Monkbrain", users(:arkadiusz).to_param
	end

	context "#has_blocked?" do
	    should "return true if a user has blocked another user" do
	      assert users(:arkadiusz).has_blocked?(users(:blocked_friend))
	    end

	    should "return false if a user has not blocked another user" do
	      assert !users(:jim).has_blocked?(users(:mike))
	    end
  	end
end
