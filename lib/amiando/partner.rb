module Amiando

  ##
  # http://developers.amiando.com/index.php/REST_API_Partner
  class Partner < Resource
    map :admin_id, :adminId
    map :default_country, :defaultCountry
    map :menu_css_url, :menuCssUrl
    map :ticket_shop_css_url, :ticketShopCssUrl
    map :sso_callback, :ssoCallback
    map :referrer_partner_id, :referrerPartnerId

    ##
    # Creates a partner.
    #
    # @param [Hash] attributes
    #
    # @return [Partner] but will only have the id loaded
    def self.create(attributes)
      object = new
      post object, '/api/partner/create',
        :params          => map_params(attributes),
        :populate_method => :populate_create

      object
    end

    ##
    # Updates the partner.
    #
    # @param id the internal id of the partner to update.
    # @param [Hash] attributes
    #
    # @return [Result] saying if the update was successful
    def self.update(id, attributes)
      object = Result.new
      post object, "/api/partner/#{id}", :params => map_params(attributes)

      object
    end

    ##
    # Find a partner
    #
    # @param id id of the partner
    #
    # @return [Partner] the partner with that id
    def self.find(id)
      object = new
      get object, "/api/partner/#{id}"

      object
    end

    private

    def populate(response_body)
      extract_attributes_from(response_body, 'partner')
    end
  end
end
