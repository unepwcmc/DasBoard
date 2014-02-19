# DasBoard
A Dashboard to allow drafting objectives for projects, then evaluating them based on visualisations of metrics.

# Setup
## Persistence
The application uses [CouchDB](https://en.wikipedia.org/wiki/CouchDB) for persistence. Install it with your package manager of choice.
CouchDB is a NoSQL store, which you query using map/reduce functions. These map/reduce functions are store in in design views in the database.  Queries are performed over HTTP.

## Our CouchDB wrapper
As such, we've ditched ActiveRecord, and replaced it with our own lightweight wrapper.
The library lives in `lib/couch_db.rb`, and is initialized by config/initializers/couchdb.rb

### Setup
It uses `config/database.yml`, same as a typical ActiveRecord application. Check the example files check in for the details.

### Design documents
Write your design documents in `app/design_documents/`. Store them as JS files, and they are automatically inserted into your Couch Database on application boot-up.

### API

#### `Couch`
This is the basic class which manages low level interactions with CouchDB. It exposes methods for each of the HTTP verbs (e.g. `Couch.get` etc.), give each of them a URL and they query CouchDb directly.

#### `Couch::Db`
Like above, but all interactions are namespaced to `/<database>/`, where <database> is the database named in your config/database.yml.

#### `Couch::Model`
Couch::Model provides a basic ORM for the different models in your CouchDb

##### `new(Hash attributes)`
Creates a model for the given attributes. The attributes are accessible in self.attributes. If the object doesn't already have a id, once is generated.

##### `id`
Convinience method for `.attributes['_id']`

##### `find(String id)`
Queries the DB for the given document, returns an instance with the attributes of thefound document.

##### `save`
Saves saves the record to the DB, updating it with the new `_rev`

##### `view(String view_name)`
Query the given view name, constructed like `"_design/#{class_name}/_view/#{view_name}"`, returns the rows.

##### `update(Hash new_attributes)`
Update the record in the DB with the new attributes. Merges attributes into the existing ones, so you need not specfy all attributes.

# Testing
Tests are keeping it simple. Written in MiniTest, using Mocha for mocking etc. Our TDD approach is something along the lines of:

1. Write an integration test for new feature, use no mocks or stubs. Have it fail
2. Write a controller test, mocking and stubbing wherever appropriate, particularly new unit methods. Make this pass.
3. Write unit test for new methods introduced in controller tests.
4. Your integration test should now be passing.

# Client interaction approach
Write me

