Exceptioner API
===============

This project is part of Exceptioner. It is a service for aggregating error notices and serving them through HTTP API. Think of it as a Hoptoad application without UI part.

Just before you ask, status is *experimental*.

Installation
------------

Getting started
---------------

API v1
------

## Summary

### Schema

All API access is over HTTP, and accessed from the ``api.exceptioner.com`` domain. All data is sent and received as JSON.

    $ curl -i http://api.exceptioner.com

    HTTP/1.1 200 OK
    Content-Type: application/json
    Status: 200 OK
    Content-Length: 2

    {}

Blank fields are included as ``null`` instead of being omitted.

All timestamps are returned in ISO 8601 format:

    YYYY-MM-DDTHH:MM:SSZ

### Client Errors

There are three possible types of client errors on API calls that receive request bodies:

1. Sending invalid JSON will result in a 400 Bad Request response.

        HTTP/1.1 400 Bad Request
        Content-Length: 35

        {"message":"Problems parsing JSON"}

2. Sending the wrong type of JSON values will result in a 400 Bad Request response.

        HTTP/1.1 400 Bad Request
        Content-Length: 40

        {"message":"Body should be a JSON Hash"}

3. Sending invalid files will result in a 422 Unprocessable Entity response.

        HTTP/1.1 422 Unprocessable Entity
        Content-Length: 161

        {
          "message": "Validation Failed",
          "errors": [
            {
              "resource": "Notice",
              "field": "exception_class",
              "code": "missing_field"
            }
          ]
        }

All error objects have resource and field properties so that your client can tell what the problem is. There’s also an error code to let you know what is wrong with the field. These are the possible validation error codes:

**missing**

This means a resource does not exist.

**missing_field**

This means a required field on a resource has not been set.

**invalid**

This means the formatting of a field is invalid. The documentation for that resource should be able to give you more specific information.

### HTTP Verbs

Where possible, API v1 strives to use appropriate HTTP verbs for each action.

**HEAD**

Can be issued against any resource to get just the HTTP header info.

**GET**

Used for retrieving resources.

**POST**

Used for creating resources.

**PATCH**

Used for updating resources with partial JSON data. A PATCH request may accept one or more of the attributes to update the resource. PATCH is a relatively new and uncommon HTTP verb, so resource endpoints also accept POST requests.

### Authentication

There is one way to authenticate through API v1:

Token sent in a header:

    $ curl -H "Api-Key: TOKEN" http://api.exceptioner.com

Token sent in a parameter:

    $ curl http://api.exceptioner.com?api_key=TOKEN

### Pagination

Requests that return multiple items will be paginated to 30 items by default. You can specify further pages with the ``?page`` parameter. You can also set a custom page size up to 100 with the ``?per_page`` parameter.

    $ curl http://api.exceptioner.com/v1/errors?page=2&per_page=100

## Notices

### List of notices for error

    GET /v1/errors/:error_id/notices

#### Response

    Status: 200 OK

    [
      {
        "id": 123,
        "error_id": 34567,
        "message": "RuntimeError: Run Forrest, run!",
        "created_at": "2011-04-22T13:33:48Z",
        "updated_at": "2011-04-22T13:33:48Z"
      }
    ]

### Show notice

    GET /v1/errors/:error_id/notices/:id

#### Response

    Status: 200 OK

    {
      "id": 123,
      "error_id": 34567,
      "message": "RuntimeError: Run Forrest, run!",
      "created_at": "2011-04-22T13:33:48Z",
      "updated_at": "2011-04-22T13:33:48Z"
    }

### Create a notice

    POST /v1/notices

#### Input

    {
      "message": "RuntimeError: Run Forrest, run!",
      "error": {
        "exception": "RuntimeError",
        "backtrace": [
          "(irb):7:in `irb_binding`",
          "...",
          "..."
        ],
        "parameters": {
          "controller": "home",
          "action": "run"
        },
        "session": {
          "key": "value"
        },
        "environment": {
          "HTTP_USER_AGENT": "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1"
        },
        "file": "[PROJECT_ROOT]/app/controllers/home_controller.rb",
        "mode": "production"
      }
    }

#### Response

    Status: 201 Created

    {
      "id": 123,
      "error_id": 34567,
      "message": "RuntimeError: Run Forrest, run!",
      "created_at": "2011-04-22T13:33:48Z",
      "updated_at": "2011-04-22T13:33:48Z"
    }

## Errors

### List errors for a project

    GET /v1/errors

#### Parameters

**resolved**

Include resolved errors, default: ``false``.

#### Response

    Status: 200 OK

    [
      {
        "id": 1234,
        "exception": "RuntimeError",
        "message": "RuntimeError: Run Forrest, run!",
        "fingerprint": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
        "file": "[PROJECT_ROOT]/app/controllers/home_controller.rb",
        "mode": "production",
        "created_at": "2011-04-22T13:33:48Z",
        "updated_at": "2011-04-22T13:33:48Z",
        "notices_count": 13
        "most_recent_notice_at": "2011-05-22T12:23:33Z",
        "resolved": false
      }
    ]


### Get a single error

    GET /v1/errors/:id

#### Response

    Status: 200 OK

    {
      "id": 1234,
      "exception": "RuntimeError",
      "message": "RuntimeError: Run Forrest, run!",
      "backtrace": [
        "(irb):7:in `irb_binding`",
        "...",
        "..."
      ],
      "parameters": {
        "key": "value"
      },
      "session": {
        "key": "value"
      },
      "environment": {
        "key": "value"
      },
      "fingerprint": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      "file": "[PROJECT_ROOT]/app/controllers/home_controller.rb",
      "mode": "production",
      "created_at": "2011-04-22T13:33:48Z",
      "updated_at": "2011-05-21T14:23:22Z",
      "notices_count": 2,
      "most_recent_notice_at": "2011-05-22T12:23:33Z",
      "resolved": true
    }

### Edit an error

    PATCH /v1/errors/:id

#### Input

    {
      "resolved": true
    }

#### Response


    Status: 200 OK

    {
      "id": 1234,
      "exception": "RuntimeError",
      "message": "RuntimeError: Run Forrest, run!",
      "backtrace": [
        "(irb):7:in `irb_binding`",
        "...",
        "..."
      ],
      "parameters": {
        "key": "value"
      },
      "session": {
        "key": "value"
      },
      "environment": {
        "key": "value"
      },
      "fingerprint": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      "file": "[PROJECT_ROOT]/app/controllers/home_controller.rb",
      "mode": "production",
      "created_at": "2011-04-22T13:33:48Z",
      "updated_at": "2011-05-21T14:23:22Z",
      "notices_count": 2,
      "most_recent_notice_at": "2011-05-22T12:23:33Z",
      "resolved": true
    }

## Deployments

### List deployments

    GET /v1/deploys

#### Response

    Status: 200 OK

    [
      {
        "id": 1234,
        "environment": "production",
        "deployed_at": "2011-05-12T23:01:05Z",
        "deployed_by": "pawelpacana",
        "repository": "git@github.com:drugpl/exceptioner-api.git",
        "revision": "e3b62dbc4e7b6301d37c591772d9aa76bd230cb6"
      }
    ]

### Show deployment

    GET /v1/deploys/:id

#### Response

    Status: 200 OK

    {
      "id": 1234,
      "environment": "production",
      "deployed_at": "2011-05-12T23:01:05Z",
      "deployed_by": "pawelpacana",
      "repository": "git@github.com:drugpl/exceptioner-api.git",
      "revision": "e3b62dbc4e7b6301d37c591772d9aa76bd230cb6"
    }

### Create a deployment

    POST /v1/deploys

#### Input

    {
      "environment": "production",
      "deployed_by": "pawelpacana",
      "repository": "git@github.com:drugpl/exceptioner-api.git",
      "revision": "e3b62dbc4e7b6301d37c591772d9aa76bd230cb6"
    }

#### Response

    Status: 201 Created

    {
      "id": 1234,
      "environment": "production",
      "deployed_at": "2011-05-12T23:01:05Z",
      "deployed_by": "pawelpacana",
      "repository": "git@github.com:drugpl/exceptioner-api.git",
      "revision": "e3b62dbc4e7b6301d37c591772d9aa76bd230cb6"
    }


Copyright
---------

Copyright (c) 2010 Paweł Pacana. See LICENSE for details.

Special thanks
--------------

- [Thoughtbot](http://thoughtbot.com/community/) - for being great open-source advocates and setting the bar with Hoptoad
- [Michał Łomnicki](http://mlomnicki.com) - for starting, pushing forward and evangelizing Exceptioner
  project
- [Dolnośląski Ruby User Group](http://drug.org.pl) - for organizing Exceptioner oriented
hackathons
