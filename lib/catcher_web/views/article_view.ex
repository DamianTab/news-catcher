defmodule CatcherWeb.ArticleView do
  use CatcherWeb, :view
  alias CatcherWeb.ArticleView

  def render("index.json", %{pageable: {articles, page}}) do
    %{data: render_many(articles, ArticleView, "article.json"), pagination: page}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      summary: article.summary,
      country: article.country,
      author: article.author,
      link: article.link,
      language: article.language,
      media: article.media,
      title: article.title,
      rights: article.rights,
      topic: article.topic,
      published_date: article.published_date}
  end

  def stale_checks("show." <> _format, %{article: data}) do
    [etag: PhoenixETag.schema_etag(data),
      last_modified: PhoenixETag.schema_last_modified(data)]
  end

end
