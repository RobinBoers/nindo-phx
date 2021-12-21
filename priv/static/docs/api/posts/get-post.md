# Get post

Used to get a single post.

**URL** : `/posts/:id`

**Method** : `GET`

**Auth required** : NO

**Data constraints** :

```json
{
    "id": "[int]"
}
```

## Success Response

**Code** : `200 OK`

**Content example** :

```json
{
    "author_id": 13,
    "title": "RSS feeds via Phx client!",
    "body": "I updated the phoenix client to show your subs to RSS feeds. It also allows you to add and remove them. Besides that I also added the ability to actually login and I started working on the account page. Next is to rebuild the CLI because I broke it by recent changes to Nindo Core and I also want to finish the Feed/Home page before weekend.",
    "image": null,
    "datetime": "2021-11-10T16:44:26"
}
```

## Error Response

**Condition** : If the requested post doesn't exist

**Code** : `404 NOT FOUND`

**Content** :

```json
null
```
