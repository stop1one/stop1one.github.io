# frozen_string_literal: true

require 'fileutils'

# Dynamically set media_subpath to the post's URL so that relative image paths
# (e.g. images/pic.png) are resolved correctly by the Chirpy theme.
Jekyll::Hooks.register :posts, :pre_render do |post|
  unless post.data.key?('media_subpath')
    post.data['media_subpath'] = post.url
  end
end

# Copy post-specific images from the source post directory to the destination
# directory in the built _site folder.
Jekyll::Hooks.register :posts, :post_write do |post|
  post_src_dir = File.dirname(post.path)
  images_src_dir = File.join(post_src_dir, 'images')

  if Dir.exist?(images_src_dir)
    post_dest_dir = File.dirname(post.destination(post.site.dest))
    images_dest_dir = File.join(post_dest_dir, 'images')

    Jekyll.logger.info "Post Images:", "Copying #{images_src_dir} to #{images_dest_dir}..."
    FileUtils.mkdir_p(images_dest_dir)
    FileUtils.cp_r(File.join(images_src_dir, '.'), images_dest_dir)
  end
end
