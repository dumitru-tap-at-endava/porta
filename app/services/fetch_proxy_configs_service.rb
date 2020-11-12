# frozen_string_literal: true

module FetchProxyConfigsService
  module_function

  # TODO: test version nil or host nil

  def call(environment:, scope: ProxyConfig.all, host: nil, version: nil)
    if version.to_s == 'latest'
      ProxyConfig.where.has { id.in(my {latest_proxy_config_ids(scope, environment, host)}) }
    else
      scope = scope.where(version: version) if version
      scope.by_environment(environment).by_host(host)
    end
  end

  def latest_proxy_config_ids(scope, environment, host)
    scope
      .selecting { MAX(id).as('id') }
      .by_environment(environment)
      .by_host(host)
      .grouping { proxy_id }
      .when_having { MAX(version) > 0 }
  end

  class ProxyIdsForOwnerAndWatcher
    def initialize(owner:, watcher: nil)
      # watcher being the user/account who does the request (to check the permissions!)
      # owner being either the service that owns the proxy configs or the tenant who does

      @watcher = watcher
      @owner = owner
    end

    def scope
      ProxyConfig.where.has { proxy_id.in(my {proxy_ids}) }
    end

    def self.scope(**args)
      new(**args).scope
    end

    private

    attr_reader :watcher, :owner

    def proxy_ids
      @proxy_ids ||= Proxy.where(service_id: service_ids).pluck(:id)
    end

    def service_ids
      accessible_services_ids & member_permission_service_ids
    end

    def accessible_services_ids
      case owner
      when Account then owner.accessible_services.pluck(:id)
      when Service then [owner.id]
      else []
      end
    end

    def member_permission_service_ids
      ids = watcher.try(:forbidden_some_services?) ? watcher.member_permission_service_ids : nil
      ids || accessible_services_ids
    end
  end

end
