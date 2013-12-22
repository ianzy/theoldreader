require 'multi_json'

require 'theoldreader/version'
require 'theoldreader/api/service'
require 'theoldreader/errors'
require 'theoldreader/core_ext/string'
require 'theoldreader/core_ext/hash'
require 'theoldreader/base'
require 'theoldreader/config'

module Theoldreader

  def self.set_token(token)
    Theoldreader::Config.token = token
  end

  def self.fetch_token(email, password, app_name)
    Theoldreader::API::Service.instance.make_request(:post, '', {client: app_name,
      accountType: 'HOSTED_OR_GOOGLE', service: 'reader', Email: email, Passwd: password}, {},
      {base_path: '/accounts/ClientLogin'}).body
  end

  def self.status
    Theoldreader::Base.get({}, endpoint: 'status')
  end

  def self.token
    Theoldreader::Base.get({}, endpoint: 'token')
  end

  def self.user_info
    Theoldreader::Base.get({}, endpoint: 'user-info')
  end

  def self.preference
    Theoldreader::Base.get({}, endpoint: 'preference/list')
  end

  def self.friends
    Theoldreader::Base.get({}, endpoint: 'friend/list')
  end

  def self.tags
    Theoldreader::Base.get({}, endpoint: 'tag/list')
  end

  def self.stream_preference
    Theoldreader::Base.get({}, endpoint: 'preference/stream/list')
  end

  def self.update_stream_preference(params)
    Theoldreader::Base.post({}, endpoint: 'preference/stream/set')
  end

  def self.rename_tag(src, dest)
    Theoldreader::Base.post({s: src, dest: dest}, endpoint: 'rename-tag')
  end

  def self.delete_tag(tag_name)
    Theoldreader::Base.post({s: tag_name}, endpoint: 'disable-tag')
  end

  def self.unread_count
    Theoldreader::Base.get({}, endpoint: 'unread-count')
  end

  def self.subscriptions
    Theoldreader::Base.get({}, endpoint: 'subscription/list')
  end

  def self.subscription_opml
    Theoldreader::API::Service.instance.make_request(:get, 'subscriptions/export', {}, Theoldreader::Base.auth_header, {base_path: '/reader'}).body
  end

  def self.add_subscription(subscription)
    Theoldreader::Base.post({quickadd: subscription}, endpoint: 'subscription/quickadd')
  end

  def self.update_subscription(subscription_id, params = {})
    filtered_params = filter_params(%w{t a r}, params)
    Theoldreader::Base.post(filtered_params.merge({ac: 'edit', s: subscription_id}), endpoint: 'subscription/edit')
  end

  def self.delete_subscription(subscription_id)
    Theoldreader::Base.post({ac: 'unsubscribe', s: subscription_id}, endpoint: 'subscription/edit')
  end

  def self.item_ids(params = {})
    filtered_params = filter_params(%w{s xt n r c nt ot}, params)
    Theoldreader::Base.get(filtered_params, endpoint: 'stream/items/ids')
  end

  def self.items(params = {})
    filtered_params = filter_params(%w{i output}, params)
    Theoldreader::Base.post(filtered_params, endpoint: 'stream/items/contents')
  end

  def self.stream(params = {})
    filtered_params = filter_params(%w{i output}, params)
    Theoldreader::Base.get(filtered_params, endpoint: 'stream/contents')
  end

  def self.mark_all_as_read(params = {})
    filtered_params = filter_params(%w{s ts}, params)
    Theoldreader::Base.post(filtered_params, endpoint: 'mark-all-as-read')
  end

  def self.update_items(params = {})
    filtered_params = filter_params(%w{i output}, params)
    Theoldreader::Base.post(filtered_params, endpoint: 'edit-tag')
  end

  def self.atom_feed(path)
    Theoldreader::API::Service.instance.make_request(:get, path, {}, Theoldreader::Base.auth_header, {base_path: '/reader/atom'}).body
  end

private

  def self.filter_params(fields, params)
    params.slice(*fields.concat(fields.map(&:to_sym)))
  end
end
