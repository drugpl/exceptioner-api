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

**already_exists**
This means another resource has the same value as this field. This can happen in resources that must have some unique key (such as Label names).

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

### Create a notice

#### Parameters

#### Response

## Errors

### List errors for a project

#### Parameters

#### Response

### Get a single error

#### Parameters

#### Response

### Edit an error

#### Parameters

#### Response

## Deployments

### Create a deployment

#### Parameters

#### Response

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
