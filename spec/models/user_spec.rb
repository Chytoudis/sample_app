require 'spec_helper'

describe User do
  #creates an instance variable @user storing data
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

subject { @user }
  #there should be a name
  it { should respond_to(:name) }
  #there should be an email
  it { should respond_to(:email) }
  #password is digested in a hash
  it { should respond_to(:password_digest) }
  #there should be a password
  it { should respond_to(:password) }
  #there should be a password confirmation
  it { should respond_to(:password_confirmation) }
  #there should be a remember token
  it { should respond_to(:remember_token) }
  #authentication tests
  it { should respond_to(:authenticate) }

  #user should be be also valid
  it { should be_valid }
  #checks the presence of the name
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  #checks the presence of the mail
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  #checks the length of the name 
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  #checks if the mail format is valid
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  #what to do if email format is valid
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end  
  #checks for uniquess of email
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  #test for lack of password
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end
  #when passwords given do not match
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  #when password lenght is too short
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  #finds user by email, tests the return value
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
  #when password is invalid  
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  #remember token should not be blank
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end