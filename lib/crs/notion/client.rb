# frozen_string_literal: true

require_relative "client/version"

module Crs
  module Notion
    class Client
      attr_accessor :headers

      def initialize(notion_token: nil)
        @headers = {
          "Authorization" => "Bearer #{notion_token}",
          "Notion-Version" => "2021-05-13",
          "Content-Type" => "application/json"
        }
      end

      def get_page(id:)
        endpoint = "https://api.notion.com/v1/pages/#{id}"

        # HTTPartyを使ってGETリクエストを送信
        response = ::HTTParty.get(endpoint, headers:)
        raise "Notion API Error: #{response.code}, #{response.message}" if response.code != 200

        JSON.parse(response.body)
      end
    end
  end
end
