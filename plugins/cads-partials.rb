# frozen_string_literal: true

# grab design-system partials for temporary use in this site
# won't need to do this once they are all ViewComponents in the design-system engine gem

cads_partials_dir = './node_modules/@citizensadvice/design-system/haml/'
cads_partials = Dir["#{cads_partials_dir}*.haml"]
dest_folder = './src/_partials/cads/'

cads_partials.each do |partial|
  dest_file = "#{dest_folder}#{File.basename(partial).chomp('.html.haml')}.haml"
  FileUtils.cp(partial, dest_file) unless File.exist? dest_file
end
