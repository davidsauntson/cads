# frozen_string_literal: true

# add design-system locale dictionaries

I18n.available_locales = [:en]
I18n.load_path += Dir['./node_modules/@citizensadvice/design-system/locales/*.yml']
