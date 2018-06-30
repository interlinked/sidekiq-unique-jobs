# frozen_string_literal: true

module SidekiqHelpers
  include SidekiqUniqueJobs::Connection

  def push_item(item = {})
    Sidekiq::Client.push(item)
  end

  def zcard(queue)
    redis { |conn| conn.zcard(queue) }
  end

  def zcount(queue, min = '-inf', max = '+inf')
    redis { |conn| conn.zcount(queue, min, max) }
  end

  def hexists(hash, key)
    redis { |conn| conn.hexists(hash, key) }
  end

  def hlen(hash, key)
    redis { |conn| conn.hlen(hash, key) }
  end

  def get_key(key)
    redis { |conn| conn.get(key) }
  end

  def set_key(key, value)
    redis { |conn| conn.set(key, value) }
  end

  def dead_count
    zcard('dead')
  end

  def schedule_count
    zcard('schedule')
  end

  def schedule_count_at(max = Time.now.to_f + 2 * 60)
    zcount('schedule', '-inf', max)
  end

  def queue_count(queue)
    redis { |conn| conn.llen("queue:#{queue}") }
  end

  def keys(pattern = nil)
    SidekiqUniqueJobs::Util.keys(pattern)
  end

  def unique_keys
    keys('uniquejobs:*')
  end

  def ttl(key)
    redis { |conn| conn.ttl(key) }
  end
end

RSpec.configure do |config|
  config.include SidekiqHelpers
end
