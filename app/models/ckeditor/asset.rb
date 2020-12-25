# frozen_string_literal: true

module Ckeditor
  class Asset < ActiveRecord::Base
    include Ckeditor::Orm::ActiveRecord::AssetBase
    include Ckeditor::Backend::Paperclip
  end
end
