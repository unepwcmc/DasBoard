mocha.setup({
  ui: 'qunit',
  globals: ['$', 'jQuery*'],
  bail: true
})

window.assert = chai.assert
