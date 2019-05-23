<p align="center">
  <img src="https://github.com/louisritchie/monarchive/blob/master/assets/static/images/branding/logo.png" />
</p>

# Monarchive

A single-user, single-codebase (standalone) archiving utility web-app.
The user organizes information into Subjects and Records.
Subjects and Records are created, edited, and deleted.
Write paragraphs of content for each Record and Subject,
and upload images as hero images, or to supplement each paragraphs.

(TODO) Connect Subjects to Records to improve organization of your archive.

## Software Versions

These versions are not strict. For example, compiling Elixir with a different version of OTP may not hinder the app.

  * Erlang/OTP 21
  * Elixir 1.8.1 (compiled with Erlang/OTP 20)
  * Node v8.11.3
  * Postgresql 9.5

Make sure that you have this software installed. Again, it is probably not the case that the versions need to be exact.
Only if you run into problems should you ensure that your software versions match those listed above.

## Installation

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`. You may also do `iex -S mix phx.server` so that the iex command line 
is available to you after the server is started & your modules are loaded.
  * Recompile the application code in iex with `recompile()`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
