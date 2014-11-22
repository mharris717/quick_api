require 'sinatra/base'
require 'mharris_ext'
require 'mongo'
require 'json'

class Conn
  fattr(:client) do
    Mongo::MongoClient.new
  end

  # fattr(:db) do
  #   client['example-db']
  # end
end

class QuickApi < Sinatra::Base
  fattr(:conn) do
    Conn.new
  end

  def insert(name)
    coll.insert(params[name])
    {}.to_json
  end

  def get_all(name)
    raw = coll.find.to_a

    json = raw.each do |row|
      id = row["_id"]
      row["id"] = id.to_s
      row.delete("_id")
    end

    res = {plural => json}
    puts res.inspect
    res.to_json
  end

  helpers do
    def name
      params[:plural][0..-2]
    end
    def plural
      params[:plural]
    end
    def db
      conn.client[token]
    end
    def coll
      db[name]
    end
    def token
      params[:token]
    end
  end

  get "/resource/:token/:plural" do
    get_all(name)
  end

  get "/resource/:token/:plural/create" do
    insert(name)
  end

  get "/resource/:token/:plural/reset" do
    coll.remove
    coll.insert({name: "FUN"})
    {}.to_json
  end

  class << self
    # def resource(name)
    #   plural = "#{name}s"

    #   get("/#{plural}") do
    #     get_all(name)
    #   end

    #   get("/#{plural}/create") do
    #     insert(name)
    #   end

    #   post(plural) do
    #     insert(name)
    #   end
    # end
  end
end

class MyApi < QuickApi
  #resource "card"

  # get "/reset" do
  #   coll = conn.db['card']
  #   coll.remove
  #   coll.insert({name: "FUN"})
  # end
end

