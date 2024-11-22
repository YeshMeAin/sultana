module CacheableQueries
  extend ActiveSupport::Concern
  EXPIRATION_TIME = 1.hour

  class_methods do
    def cached_find(id)
      Rails.cache.fetch([cache_key_prefix, id], expires_in: EXPIRATION_TIME) do
        find(id)
      end
    end

    def cached_count
      Rails.cache.fetch([cache_key_prefix, 'count'], expires_in: EXPIRATION_TIME) do
        count
      end
    end

    def cached_where(conditions)
      cache_key = [cache_key_prefix, 'where', conditions.hash]
      Rails.cache.fetch(cache_key, expires_in: EXPIRATION_TIME) do
        where(conditions).to_a
      end
    end

    private

    def cache_key_prefix
      "#{name.underscore}/v1"
    end
  end
end 