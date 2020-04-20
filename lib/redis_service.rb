# frozen_string_literal: true

$redis = Redis.new(Rails.application.config_for(:redis))
