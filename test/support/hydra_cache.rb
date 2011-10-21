module HydraCache
  extend self

  attr_accessor :prefix

  def setter(request)
    set_cache request
  end

  def getter(request)
    if response = get_cache(request)
      response.request = request
    else
      request.cache_timeout = 1
    end

    response
  end

  def get_cache(request)
    filename = cache_filename(request)

    if File.exist?(filename)
      YAML.load_file(filename)
    else
      false
    end
  end

  def set_cache(request)
    filename = cache_filename(request)
    response = request.response
    response.request = request.inspect

    FileUtils.mkdir_p(File.dirname(filename))
    File.open(filename, 'w') do |f|
      f << response.to_yaml
    end
  end

  def cache_filename(request)
    uri = URI.parse(request.url)
    uri.query = uri.query.split('&').sort.join('&')

    body = request.body.to_s.split(/\n/).map do |line|
      Digest::SHA1.hexdigest(line)
    end.sort.join

    params = request.params.map do |k,v|
      Digest::SHA1.hexdigest("#{k},#{v}")
    end.sort.join

    digest = Digest::MD5.hexdigest("#{uri}|#{body}|#{params}")

    File.join(File.dirname(__FILE__),'..','fixtures', prefix.to_s.gsub(/\W+/,'_'), "#{digest}.yml")
  end

end
