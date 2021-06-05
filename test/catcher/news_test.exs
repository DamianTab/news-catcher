defmodule Catcher.NewsTest do
  use Catcher.DataCase

  alias Catcher.News

  describe "articles" do
    alias Catcher.News.Article

    @valid_attrs %{author: "some author", country: "some country", language: "some language", link: "some link", media: "some media", published_date: ~N[2010-04-17 14:00:00], rights: "some rights", summary: "some summary", title: "some title", topic: "some topic"}
    @update_attrs %{author: "some updated author", country: "some updated country", language: "some updated language", link: "some updated link", media: "some updated media", published_date: ~N[2011-05-18 15:01:01], rights: "some updated rights", summary: "some updated summary", title: "some updated title", topic: "some updated topic"}
    @invalid_attrs %{author: nil, country: nil, language: nil, link: nil, media: nil, published_date: nil, rights: nil, summary: nil, title: nil, topic: nil}

    def article_fixture(attrs \\ %{}) do
      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> News.create_article()

      article
    end

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert News.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert News.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      assert {:ok, %Article{} = article} = News.create_article(@valid_attrs)
      assert article.author == "some author"
      assert article.country == "some country"
      assert article.language == "some language"
      assert article.link == "some link"
      assert article.media == "some media"
      assert article.published_date == ~N[2010-04-17 14:00:00]
      assert article.rights == "some rights"
      assert article.summary == "some summary"
      assert article.title == "some title"
      assert article.topic == "some topic"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = News.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, %Article{} = article} = News.update_article(article, @update_attrs)
      assert article.author == "some updated author"
      assert article.country == "some updated country"
      assert article.language == "some updated language"
      assert article.link == "some updated link"
      assert article.media == "some updated media"
      assert article.published_date == ~N[2011-05-18 15:01:01]
      assert article.rights == "some updated rights"
      assert article.summary == "some updated summary"
      assert article.title == "some updated title"
      assert article.topic == "some updated topic"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = News.update_article(article, @invalid_attrs)
      assert article == News.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = News.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> News.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = News.change_article(article)
    end
  end
end
