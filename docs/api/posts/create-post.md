# New post

Used to publish a new post.

**URL** : `/posts`

**Method** : `PUT`

**Auth required** : YES

**Data constraints** :

```json
{
    "title": "[string]",
    "body": "[string]",
    "token": "[string]"
}
```

## Success Response

**Code** : `201 CREATED`

**Content example** :

```json
{
    "message": "Success! You can close this tab now."
}
```

## Error Response

**Condition** : If something went wrong publishing the post with one of these reasons:

- Invalid token

**Code** : `400 BAD REQUEST`

**Content** :

```json
{
    "message": "Error: something went wrong."
}
```
