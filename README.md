# blog-api
Ruby on Rails API application.

## Setup
```
bundle install
rake db:setup
```

## Available resources
### POST /v1/posts
Creates a new post and returns the new post object attributes.

Example request body:
```
{
    "title": "Post title",
    "content": "Some text",
    "ip": "127.1.1.1"
    "login": "Shub-Niggurath",
}
```

### POST /v1/posts/:post_id/ratings
Creates a new rate for a post and returns posts average rating.

Example request body:
```
{
    "post_id": "14",
    "value": "5"
}
```

### GET /v1/ips
Returns N top posts.

### GET /v1/ips
Returns list of ips with multiple logins.
