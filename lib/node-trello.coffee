rest = require "restler"

class Trello
  # Creates a new Trello request wrapper.
  # Syntax: new Trello(applicationApiKey, userToken)
  constructor: (key, token) ->
    throw new Error "Application API key is required" unless key?
    @key = key
    @token = token
    @host = "https://api.trello.com"

  # Make a GET request to Trello.
  # Syntax: trello.get(uri, [query], callback)
  get: () ->
    Array.prototype.unshift.call arguments, "GET"
    @request.apply this, arguments

  # Make a POST request to Trello.
  # Syntax: trello.post(uri, [query], callback)
  post: () ->
    Array.prototype.unshift.call arguments, "POST"
    @request.apply this, arguments

  # Make a PUT request to Trello.
  # Syntax: trello.put(uri, [query], callback)
  put: () ->
    Array.prototype.unshift.call arguments, "PUT"
    @request.apply this, arguments

  # Make a DELETE request to Trello.
  # Syntax: trello.del(uri, [query], callback)
  del: () ->
    Array.prototype.unshift.call arguments, "DELETE"
    @request.apply this, arguments

  # Make a request to Trello.
  # Syntax: trello.request(method, uri, [query], callback)
  request: (method, uri, argsOrCallback, callback) ->
    if arguments.length is 3 then callback = argsOrCallback; args = {}
    else args = argsOrCallback || {}

    options = method: method, query: @addAuthArgs args
    url = @host + (if uri[0] is "/" then "" else "/") + uri

    request = rest.request url, options
    request.on "success", (data, res) -> callback.call res, null, data
    request.on "fail", (data, res) -> callback.call res, data, null
    request.on "error", (error, res) -> callback.call res, error, null

  addAuthArgs: (args) ->
    args.key = @key
    args.token = @token if @token
    return args

module.exports = Trello