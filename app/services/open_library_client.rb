class OpenLibraryClient
  BASE = "https://openlibrary.org/api/books"

  def self.fetch_by_isbn(isbn13)
    resp = Faraday.get(BASE, { bibkeys: "ISBN:#{isbn13}", format: "json", jscmd: "data" })
    return {} unless resp.success?

    json = JSON.parse(resp.body) rescue {}
    data = json["ISBN:#{isbn13}"] || {}
    {
      title: data["title"],
      number_of_pages: data["number_of_pages"]
    }.compact
  end
end