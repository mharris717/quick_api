require 'rspec'
require 'open-uri'
require 'json'

def get_json(url)
  raw = open("#{root_url}/#{url}").read
  JSON.parse(raw)
end

def root_url
  "http://localhost:9292"
end

def token 
  "abc"
end

describe "smoke" do
  it "smoke" do
    2.should == 2
  end

  before do
    open("#{root_url}/resource/#{token}/cards/reset").read
  end

  it 'get all' do
    res = get_json("resource/#{token}/cards")
    res['cards'].size.should == 1
  end

  it 'create' do
    get_json("resource/#{token}/cards/create?card[name]=abc")

    res = get_json("resource/#{token}/cards")
    res['cards'].size.should == 2
  end


end