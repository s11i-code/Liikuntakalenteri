# encoding: utf-8

require 'net/http'
require 'net/https'


class YolConnection

  attr_reader :cookie

  USER_AGENT = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; fi; rv=>1.9.2.13) Gecko/20101203 Firefox/3.6.13"
  
  def authenticate(username, password)
    h = Net::HTTP.new('yliopistoliikunta.helsinki.fi', 443)
    h.use_ssl = true
    resp = ""
    h.start do |http|
      form_path = '/yol/webauth/fi/reservations/listReservations.do?login=true'
      # GET request -> so the host can set his cookies
      resp, data = http.get(form_path, {'User-Agent' => USER_AGENT})
      @cookie = resp.response['set-cookie'].split('; ')[0]
      # POST request -> logging in
      post_path ="https://yliopistoliikunta.helsinki.fi/yol/webauth/fi/event/j_security_check"
      data = "j_username=#{username}&j_password=#{password}&WEBLOGIN=Kirjaudu"
      headers = YolConnection.common_headers.merge('Cookie' => @cookie, 'Content-Type' => 'application/x-www-form-urlencoded' )
      resp, data = http.post(post_path, data, headers)
    end
    resp.code == "302"
  end

 

  def reserve_event(yol_event_id)
    headers = YolConnection.common_headers.merge('Cookie' => @cookie )
    h = Net::HTTP.new('yliopistoliikunta.helsinki.fi', 443)
    h.use_ssl = true
    resp = ""
    path="/yol/webauth/fi/event/listEvents.do?reserveEvent=" + yol_event_id
    h.start do |http|
      resp, data = http.get(path, headers)
      resp, data = http.get(path, headers)
      resp, data = http.get(path, headers)

    end
    #resp.body =~ /Paikka tapahtumaan varattu/
    resp.body
  end

  private

  def self.common_headers
    {
      
      'Host'=> 'yliopistoliikunta.helsinki.fi',
      'User-Agent'=> USER_AGENT
    }

  end
end
