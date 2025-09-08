# README

## Developers

- Freddy Bacigalupo
- Vicente Giaconi
- Ignacio Liberón

## Ruby version

- This project uses Ruby 3.4.5 and Rails 8.0.2 (https://guides.rubyonrails.org/install_ruby_on_rails.html).


## Local environment


### System dependencies

- To install all the required dependencies, execute:

```bash
bundle install
yarn install
```

### Database creation

- You need the PostgreSQL database engine. If you don't have it installed on your machine, follow the steps of the official documentation (https://www.postgresql.org/download/).

- To initialize the database, run the next command:

```bash
bin/rails db:setup
```

### Running the application

- To run the application, execute this command:
```bash
bin/rails server
```

### NOTE: Filters for Authors Table
The filters implemented in the authors table is not very visible. By clicking the header of each of the columns the data is filtered accordingly.

## Docker environment

### Only Base Containers (App + Database)
```bash
docker compose -f docker-compose-base.yml up --build -d
docker compose -f docker-compose-base.yml exec web rake db:setup
```

### Base + Cache Container
```bash
docker compose -f docker-compose-cache.yml up --build -d
docker compose -f docker-compose-cache.yml exec web rake db:setup
```

### Base + Reverse Proxy Container
```bash
docker compose -f docker-compose-proxy.yml up --build -d
docker compose -f docker-compose-proxy.yml exec web rake db:setup
```

### Base + Search Engine Container
```bash
docker compose -f docker-compose-search.yml up --build -d
docker compose -f docker-compose-search.yml exec web rake db:setup
docker compose -f docker-compose-search.yml exec web bin/rails runner 'Book.reindex'
docker compose -f docker-compose-search.yml exec web bin/rails runner 'Review.reindex'
```

### Everything at the same time
```bash
docker compose up --build -d
docker compose exec web rake db:setup
docker compose exec web bin/rails runner 'Book.reindex'
docker compose exec web bin/rails runner 'Review.reindex'
```

- Then search on your browser "http://localhost:3000/"
- To take down the containers, execute:
```bash
docker compose down -v
```

