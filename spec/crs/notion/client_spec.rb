# frozen_string_literal: true

require "httparty"
require "json"

RSpec.describe Crs::Notion::Client do
  let(:notion_token) { "secret_test_token_12345" }
  let(:client) { described_class.new(notion_token: notion_token) }
  let(:page_id) { "12345678-1234-1234-1234-123456789abc" }
  let(:sample_page_response) do
    {
      "object" => "page",
      "id" => page_id,
      "created_time" => "2023-01-01T00:00:00.000Z",
      "last_edited_time" => "2023-01-01T00:00:00.000Z",
      "properties" => {
        "title" => {
          "id" => "title",
          "type" => "title",
          "title" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Test Page"
              }
            }
          ]
        }
      }
    }
  end

  it "has a version number" do
    expect(Crs::Notion::Client::VERSION).not_to be nil
  end

  describe "#initialize" do
    context "when notion_token is provided" do
      it "sets up headers correctly" do
        expect(client.headers).to include(
          "Authorization" => "Bearer #{notion_token}",
          "Notion-Version" => "2021-05-13",
          "Content-Type" => "application/json"
        )
      end
    end

    context "when notion_token is nil" do
      let(:client_without_token) { described_class.new(notion_token: nil) }

      it "sets Authorization header with Bearer nil" do
        expect(client_without_token.headers["Authorization"]).to eq("Bearer ")
      end
    end
  end

  describe "#get_page" do
    let(:endpoint) { "https://api.notion.com/v1/pages/#{page_id}" }

    context "when API call is successful" do
      let(:mock_response) do
        double("HTTParty::Response",
               code: 200,
               body: sample_page_response.to_json)
      end

      before do
        allow(HTTParty).to receive(:get)
          .with(endpoint, headers: client.headers)
          .and_return(mock_response)
      end

      it "returns parsed JSON response" do
        result = client.get_page(id: page_id)
        expect(result).to eq(sample_page_response)
      end

      it "calls HTTParty.get with correct parameters" do
        client.get_page(id: page_id)
        expect(HTTParty).to have_received(:get)
          .with(endpoint, headers: client.headers)
      end
    end

    context "when API call fails with 400 Bad Request" do
      let(:mock_response) do
        double("HTTParty::Response",
               code: 400,
               message: "Bad Request")
      end

      before do
        allow(HTTParty).to receive(:get)
          .with(endpoint, headers: client.headers)
          .and_return(mock_response)
      end

      it "raises an error with appropriate message" do
        expect { client.get_page(id: page_id) }
          .to raise_error(RuntimeError, "Notion API Error: 400, Bad Request")
      end
    end

    context "when API call fails with 401 Unauthorized" do
      let(:mock_response) do
        double("HTTParty::Response",
               code: 401,
               message: "Unauthorized")
      end

      before do
        allow(HTTParty).to receive(:get)
          .with(endpoint, headers: client.headers)
          .and_return(mock_response)
      end

      it "raises an error with appropriate message" do
        expect { client.get_page(id: page_id) }
          .to raise_error(RuntimeError, "Notion API Error: 401, Unauthorized")
      end
    end

    context "when API call fails with 404 Not Found" do
      let(:mock_response) do
        double("HTTParty::Response",
               code: 404,
               message: "Not Found")
      end

      before do
        allow(HTTParty).to receive(:get)
          .with(endpoint, headers: client.headers)
          .and_return(mock_response)
      end

      it "raises an error with appropriate message" do
        expect { client.get_page(id: page_id) }
          .to raise_error(RuntimeError, "Notion API Error: 404, Not Found")
      end
    end

    context "when API call fails with 500 Internal Server Error" do
      let(:mock_response) do
        double("HTTParty::Response",
               code: 500,
               message: "Internal Server Error")
      end

      before do
        allow(HTTParty).to receive(:get)
          .with(endpoint, headers: client.headers)
          .and_return(mock_response)
      end

      it "raises an error with appropriate message" do
        expect { client.get_page(id: page_id) }
          .to raise_error(RuntimeError, "Notion API Error: 500, Internal Server Error")
      end
    end

    context "when response body contains valid JSON" do
      let(:mock_response) do
        double("HTTParty::Response",
               code: 200,
               body: '{"test": "data"}')
      end

      before do
        allow(HTTParty).to receive(:get).and_return(mock_response)
      end

      it "parses JSON correctly" do
        result = client.get_page(id: page_id)
        expect(result).to eq({ "test" => "data" })
      end
    end
  end

  describe "headers accessor" do
    it "allows reading headers" do
      expect(client.headers).to be_a(Hash)
    end

    it "allows modifying headers" do
      original_headers = client.headers.dup
      client.headers["Custom-Header"] = "test-value"

      expect(client.headers["Custom-Header"]).to eq("test-value")
      expect(client.headers).to include(original_headers)
    end
  end

  describe "integration with real endpoint structure" do
    it "constructs correct endpoint URL" do
      expect(HTTParty).to receive(:get)
        .with("https://api.notion.com/v1/pages/#{page_id}", anything)
        .and_return(double("response", code: 200, body: "{}"))

      client.get_page(id: page_id)
    end

    it "sends required headers for Notion API" do
      expected_headers = {
        "Authorization" => "Bearer #{notion_token}",
        "Notion-Version" => "2021-05-13",
        "Content-Type" => "application/json"
      }

      expect(HTTParty).to receive(:get)
        .with(anything, headers: expected_headers)
        .and_return(double("response", code: 200, body: "{}"))

      client.get_page(id: page_id)
    end
  end
end
