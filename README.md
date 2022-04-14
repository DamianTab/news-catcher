# NewsCatcher
NewsCatcher is a simple backend application that delivers HTTP Api and search for news in every major press website all over the world. It scans through database looking for specific phrases or keywords. For simplicity it uses free API from the XrapidAPI. NewsCatcher support many query parameters like keywords, sources, different languages, date, sorting, pagination etc. What is more, it saves all found results in local database for later purposes. It automatically return local information from database in case the same or very similiar query was sent. It is possible to create users, add favourite articles/news and migrate those between different users.

Pagination and sorting supported. All Http codes and response follow the standard e.g. ETAG, 4xx, database garbage collector etc.

## Technologies (Prerequistion)
- Elixir 1.13.2
- Phoenix 1.5.9
- Ecto 3.4

## Run
1. Start docker compose
2. Start application (phoenix)
2a. Get your own Api key from https://newscatcher.p.rapidapi.com/v1/search then change x_rapidAPI_key value in article_search_params.ex

## Phoenix server
To start your Phoenix server:
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

To update database after changes use: `mix ecto.migrate`

## Docker Compose
Create postgres and pgAdmin4: `docker-compose up -d`
Start postgres and pgAdmin4: `docker-compose start`
Stop postgres and pgAdmin4: `docker-compose stop`
Delete postgres and pgAdmin4: `docker-compose down`


## Examples



## Learn more about Elixir and Phoenix webframework

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
