module Amiando

  ##
  # http://developers.amiando.com/index.php/REST_API_Users
  class User < Resource
    map :first_name, :firstName
    map :last_name,  :lastName

    ##
    # Will return a {Boolean} deferred object containing the result
    #
    # @param [String] username
    def self.exists?(username)
      object  = Boolean.new('exists')
      request = get object, "api/user/exists",
        :params => { :username => username }

      object
    end

    ##
    # Find a user given the username (email)
    #
    # @param [String] username
    # @return [Result] with the user's id
    def self.find_by_username(username)
      object = Result.new do |response_body|
        response_body['ids'].first
      end

      request = get object, "api/user/find",
        :params => { :username => username }

      object
    end

    ##
    # Creates a user. It will not return the full user and only the id
    # attribute will be available.
    #
    # @params [Hash] attributes
    def self.create(attributes)
      object  = new
      request = post object, '/api/user/create',
        :params          => map_params(attributes),
        :populate_method => :populate_create

      object
    end

    ##
    # Updates a user.
    # Will return a {Boolean} deferred object indicating
    # the result of the update
    #
    # @param [String] username
    def self.update(user_id, attributes)
      object  = Boolean.new('success')
      request = post object, "/api/user/#{user_id}", :params => map_params(attributes)

      object
    end

    ##
    # Find a user.
    # Will return a user
    #
    # @param user_id
    def self.find(user_id)
      object = new
      request = get object, "api/user/#{user_id}"

      object
    end

    ##
    # Deletes a user
    # Returns a {Boolean} with the result of the operation
    #
    # @param user_id
    def self.delete(user_id)
      object = Boolean.new('deleted')
      request = do_request object, :delete, "/api/user/#{user_id}"

      object
    end

    ## Request permission to use and api key on behalf of a user
    #
    # @param user_id
    # @param [String] password
    def self.request_permission(user_id, password)
      object = Result.new do |response_body, result|
        if response_body['success']
          true
        else
          result.errors = response_body['errors']
          false
        end
      end

      request = post object, "api/user/#{user_id}/requestPermission", :params => { :password => password }

      object
    end

    ##
    # Tries to log out the user_id. Will raise Error::NotAuthorized if
    # trying to logout a user you don't have permission for.
    #
    # @param user_id
    def self.logout(user_id)
      object = Boolean.new('success')
      request = post object, "/api/user/#{user_id}/logout"

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
    # def request_permission(user_id, password)
    #   post "api/user/#{user_id}/requestPermission", :password => password
    # end

    # def events(user_id)
    #   get "api/user/#{user_id}/events"
    # end

    def ==(user)
      id == user.id
    end
  end

end
