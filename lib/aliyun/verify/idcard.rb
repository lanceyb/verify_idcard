module Aliyun
  module Verify
    class Idcard

      VERIFY_URL = 'http://aliyunverifyidcard.haoservice.com/idcard/VerifyIdcardv2'

      attr_accessor :card_no, :name

      def initialize(card_no, name, app_code = ENV['app_code'])
        @name = name
        @card_no = card_no
        @app_code = app_code
      end

      def verify
        http_call
      end

      def http_call
        begin
          uri = URI.parse(VERIFY_URL)
          params = { cardNo: card_no, realName: name }
          uri.query = URI.encode_www_form(params)
          http = Net::HTTP.new(uri.host, uri.port).start
          request = Net::HTTP::Get.new(uri.request_uri, { 'Authorization' => "APPCODE #{@app_code}" })
          res = http.request(request)
          if res.is_a?(Net::HTTPOK)
            JSON.parse(res.body)
          else
            { error_code: 98, reason: res.inspect }
          end
        rescue => e
          { error_code: 99, reason: e.to_s }
        end
      end
    end
  end
end