module Amiando

  ##
  # http://developers.amiando.com/index.php/REST_API_Users
  class User < Resource
    self.mapping = {
      :first_name => :firstName,
      :last_name  => :lastName
    }

    ##
    # Creates a user. It will not return the full user and only the id
    # attribute will be available.
    def self.create(attributes)
      object  = new
      request = post object, '/api/user/create',
        :params          => map_params(attributes),
        :populate_method => :populate_create

      object
    end

    ##
    # Will return a {Boolean} object to whom you can ask the result
    # after the queue has been run.
    #
    # @param [String] username
    def self.exists?(username)
      object  = Boolean.new('exists')
      request = get object, "api/user/exists", :params => { :username => username }

      object
    end

    def populate(response_body)
      extract_attributes_from(response_body, 'user')
    end

    def populate_create(response_body)
      @attributes = {:id => response_body['id']}
      @success    = response_body['success']
    end

    # def bank_account(id)
    #   request :get, "api/user/#{id}/bankAccount"
    # end

    # def address_billing(id)
    #   request :get, "api/user/#{id}/address/billing"
    # end

    ##
    # Tries to get permission to work on user_id.
    def request_permission(user_id, password)
      post "api/user/#{user_id}/requestPermission", :password => password
    end

    ##
    # Tries to log out the user_id. Will raise Error::NotAuthorized if
    # trying to logout a user you don't have permission for. Will return
    # a hash with "success" set to true or false.
    def logout(user_id)
      post "api/user/#{user_id}/logout"
    end

    def events(user_id)
      get "api/user/#{user_id}/events"
    end
  end

end
