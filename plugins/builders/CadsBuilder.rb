require "action_dispatch"
require "rails/engine"
require "citizens_advice_components"
require "pry"

class CadsBuilder < SiteBuilder
  def build
    make_test_posts
    load_cads
    build_components_collection
  end

  def build_components_collection
    ViewComponent::Preview.descendants.each do |preview|
      data = preview_data(preview)
      front_matter = { layout: "preview" }

      data[:variants].each do |variant|
        example_html = example_html(data[:name], variant)

        doc "#{data[:name]}_#{variant}.md" do
          collection "previews"
          content example_html
          front_matter front_matter
        end
      end
    end
  end

  def example_html(name, variant)
    begin
      File.read("./examples/#{name}/#{variant}.html")
    rescue Errno::ENOENT
      puts "Cannot find example HTML in './examples/#{name}/#{variant}.html'"
    end
  end

  def preview_data(preview) 
    {
      layout: "preview",
      name: preview.name.partition("::").last.chomp("Preview").underscore,
      variants: preview.examples,
    }
  end

  def make_test_posts
    %w[one two three four].each do |post|
      doc "#{post}.md" do 
        collection "posts"
        content post
      end
    end
  end

  def load_cads
    site.config.loaded_cads ||= begin
      cads_loader = Zeitwerk::Loader.new
      CitizensAdviceComponents::Engine.config.my_paths.each do |path|
        cads_loader.push_dir path
      end
      cads_loader.setup
      cads_loader.eager_load
      true
    end
  end
end