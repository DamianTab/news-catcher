defmodule CatcherWeb.ArticleView do
  use CatcherWeb, :view
  alias CatcherWeb.ArticleView

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, ArticleView, "article.json")}
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
end
