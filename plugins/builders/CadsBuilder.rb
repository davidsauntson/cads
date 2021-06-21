# frozen_string_literal: true

require 'action_dispatch'
require 'rails/engine'
require 'citizens_advice_components'

# We have a bug somewhere between bridgetown and citizens_advice_components which
# prevents haml from being seen as a tempalte handler. A simple workaround is to
# manually re-register the handler.
require 'haml/plugin'

ActionView::Template.register_template_handler(:haml, Haml::Plugin)

class CadsBuilder < SiteBuilder
  def build
    load_cads
    build_components_collection
  end

  def build_components_collection
    ViewComponent::Preview.descendants.each do |preview|
      data = preview_data(preview)
      front_matter = { layout: 'preview' }

      data[:variants].each do |variant|
        example_html = example_html(data[:name], variant)

        doc "#{data[:name]}_#{variant}.md" do
          collection 'previews'
          content example_html
          front_matter front_matter
        end
      end
    end
  end

  def example_html(name, variant)
    File.read("./examples/#{name}/#{variant}.html")
  rescue Errno::ENOENT
    puts "Cannot find example HTML in './examples/#{name}/#{variant}.html'"
  end

  def preview_data(preview)
    {
      layout: 'preview',
      name: preview.name.partition('::').last.chomp('Preview').underscore,
      variants: preview.examples
    }
  end

  def load_cads
    site.config.loaded_cads ||= begin
      cads_loader = Zeitwerk::Loader.new
      CitizensAdviceComponents::Engine.config.autoload_paths.each do |path|
        cads_loader.push_dir path
      end
      cads_loader.setup
      cads_loader.eager_load
      true
    end
  end
end
