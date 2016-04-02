class UrlPathParser
  def parser_path(identifier, relative_path)
    client = Client.find_by(identifier: identifier)
  end
end
