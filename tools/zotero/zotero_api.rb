require 'rest-client'
require 'json'


class ZoteroApi
  def initialize(user_id, key, group)
    @user_id = user_id
    @key = key
    @group_id = group
    puts @user_id
  end

  def get(path_fragment)
    ::JSON.parse(RestClient.get("https://api.zotero.org/users/#{@user_id}/#{path_fragment}", {
      'Zotero-API-Version' => 3,
      'Zotero-API-Key' => @key
    }).body)
  end

  def get_template(itemType)
    ::JSON.parse(RestClient.get("https://api.zotero.org/items/new?itemType=#{itemType}", {
      'Zotero-API-Version' => 3,
      'Zotero-API-Key' => @key
    }).body)
  end

  def get_group(path_fragment)
    ::JSON.parse(RestClient.get("https://api.zotero.org/groups/#{@group_id}/#{path_fragment}/", {
      'Zotero-API-Version' => 3,
      'Zotero-API-Key' => @key
    }).body)
  end

  def create_collection(data)
    ::JSON.parse(RestClient.post("https://api.zotero.org/users/#{@user_id}/collections", data, {
      'Zotero-API-Version' => 3,
      'Zotero-API-Key' => @key,
      'content-type' => 'application/json'
    }).body)
  end

  def create_item(data)
    ::JSON.parse(RestClient.post("https://api.zotero.org/users/#{@user_id}/items", data, {
      'Zotero-API-Version' => 3,
      'Zotero-API-Key' => @key,
      'content-type' => 'application/json'
    }).body)
  end

end