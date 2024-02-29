# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version: `2.7.2`

- System dependencies: `postgresql`

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

### Development Setup

1. Setup `.env` file at the root of the project.

   > Get the `OPENAI_ACCESS_TOKEN` from the [account/api-keys @ OpenAI](https://beta.openai.com/account/api-keys).

   ```dosini
   # .env
   OPENAI_ACCESS_TOKEN=your_token_goes_here
   ```

2. Install dependencies

   > Make sure you have installed PostgreSQL on your machine.

   > Before running the following commands, go to `config/database.yml`, check under `development:` and make sure that `username` and `password` are correct for your machine.

   ```sh
   yarn # installs node dependencies
   bundle install # installs ruby dependencies
   rails db:create # creates a database called 'cheko_development'
   rails db:migrate # creates tables and columns according to the schema.
   rails db:seed # creates the initial data for the database.
   ```

3. Run the server
   > 💡 Tip: Run `webpack-dev-server` before running `rails server`.
   >
   > Without this, it takes **_22 seconds_** to compile after making changes to `app/javascript/packs`. Doing this cuts it down to **_6 seconds_** (helps iteratively see changes). The caveat is that any page load takes **_3-5 seconds_** long.
   ```sh
   ruby ./bin/webpack-dev-server # run the webpack-dev-server
   rails server
   ```
   Run with tailwind
   > This will run the rails server along with the tailwind watcher
   ```
   ./bin/dev
   ```
