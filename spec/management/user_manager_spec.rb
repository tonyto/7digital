require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "UserManager" do

  before do

    @an_email = "email"
    @a_password = "password"
    @a_request_token = fake_request_token
    @an_access_token = fake_access_token

    @client = stub(Sevendigital::Client)

    @oauth_manager = mock(Sevendigital::OAuthManager)
    @oauth_manager.stub!(:get_request_token).and_return(@a_request_token)
    @oauth_manager.stub!(:authorise_request_token).and_return(true)
    @oauth_manager.stub!(:get_access_token).and_return(@an_access_token)

    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @client.stub!(:oauth).and_return(@oauth_manager )
    @user_manager = Sevendigital::UserManager.new(@client)
  end

  it "authenticate should return an authenticated user if supplied with valid login details" do
    user = @user_manager.authenticate("email", "password")
    user.kind_of?(Sevendigital::User).should == true
    user.authenticated?.should == true
  end

  it "authenticate should return nil if user does not authenticate" do
    @oauth_manager.stub!(:authorise_request_token).and_return(false)
    user = @user_manager.authenticate("email", "password")
    user.nil?.should == true
  end

  it "authenticate should get a request token" do
    @client.oauth.should_receive(:get_request_token).and_return(nil)
    @user_manager.authenticate("email", "password")
  end

  it "authenticate should attempt to authorise request token" do
    @client.oauth.should_receive(:authorise_request_token).with(@an_email, @a_password, @a_request_token) \
      .and_return(true)
    @user_manager.authenticate(@an_email, @a_password)
  end

  it "authenticate should retrieve access_token for authenticated user" do
    @client.oauth.should_receive(:get_access_token).with(@a_request_token) \
      .and_return(@an_access_token)
    user = @user_manager.authenticate(@an_email, @a_password)
    user.oauth_access_token.should == @an_access_token
  end

  def fake_request_token
    token = stub(OAuth::RequestToken)
    token.stub(:token).and_return("key")
    token
  end

  def fake_access_token
    token = stub(OAuth::RequestToken)
    token.stub(:token).and_return("key")
    token
  end


end