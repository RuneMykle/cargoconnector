class CargoConnectorHelper

  def self.shopify_hash_to_cargonizer_xml(hash, transport_agreement)
  	puts hash
    xml = Builder::XmlMarkup.new(:target=>'', :indent=>2) #:target=>$stdout, :indent=>2
    xml.instruct! :xml, :version=> '1.0', :encoding=> 'UTF-8'
    xml.consignments do
      xml.consignment :transport_agreement => transport_agreement['id'] do
        xml.product transport_agreement['product']
        xml.parts do
          xml.consignee do
            xml.name String(hash['shipping_address']['first_name']) + String(hash['shipping_address']['last_name'])
            xml.address1 hash['shipping_address']['address1']
            xml.address2 hash['shipping_address']['address2']
            xml.country hash['shipping_address']['country_code']
            xml.postcode hash['shipping_address']['zip']
            xml.city hash['shipping_address']['city']
            xml.phone hash['shipping_address']['phone']
          end
        end
        xml.items do
          @items = hash['line_items']
          @items.each do |item|
            xml.item :type => 'PK', :amount => 1, :weight => 0.35, :description => item['name'] + item['sku']
          end
        end
      end
    end
  end

  def self.get_transport_agreements(key, managership, url)
    HTTParty.get(url,
                 :headers => {'X-Cargonizer-Key' => key, 'Content-Type' => 'application/xml', 'Accept' => 'application/json', 'X-Cargonizer-Sender' => managership},
    )
  end

  def self.create_consignment(key, managership, url, xml)
    HTTParty.post(url,
                  :headers => {'X-Cargonizer-Key' => key, 'Content-Type' => 'application/xml', 'Accept' => 'application/xml', 'X-Cargonizer-Sender' => managership},
                  :body => xml
    )
  end

  def self.verify_webhook(data, hmac_header, shared_secret)
    digest  = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, shared_secret, data)).strip
    calculated_hmac == hmac_header
  end

end