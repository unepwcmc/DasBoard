# DasBoard
A Dashboard to allow drafting objectives for projects, then evaluating them based on visualisations of metrics.

# Setup
## Persistence
The application uses [CouchDB](https://en.wikipedia.org/wiki/CouchDB) for persistence. Install it with your package manager of choice.
CouchDB is a NoSQL store, which you query using map/reduce functions. These map/reduce functions are stored in design views in the database. Queries are performed over HTTP.

# Testing
Tests are keeping it simple. Written in MiniTest, using Mocha for mocking etc. Our TDD approach is something along the lines of:

1. Write an integration test for new feature, use no mocks or stubs. Have it fail
2. Write a controller test, mocking and stubbing wherever appropriate, particularly new unit methods. Make this pass.
3. Write unit test for new methods introduced in controller tests.
4. Your integration test should now be passing.

# Client interaction approach
Write me

