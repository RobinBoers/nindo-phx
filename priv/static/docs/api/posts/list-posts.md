# List posts

Used to get a list of public posts.

**URL** : `/posts`

**Method** : `GET`

**Auth required** : NO

**Data constraints** :

```json
{
    "limit": "[int]"
}
```

## Success Response

**Code** : `200 OK`

**Content example** :

```json
[
    [
        {
            "author_id": 19,
            "title": "Introducing: Nindo Search",
            "body": "The \"discover\" tab now has a built in search bar. It can search Nindo for usernames, display names and descriptions. Only direct matches at this point, but it works. You can also get a permalink to a search result using this endpoint: /search/:query",
            "image": null,
            "datetime": "2021-12-01T19:25:47"
        },
        {
            "author_id": 13,
            "title": "Dark mode is here!",
            "body": "Good news for all the Night Owls reading this: we now have an official dark theme. It is built using tailwind (learn more here: https://tailwindcss.com/docs/dark-mode) and I really like it. I think this is my permanent theme now. It is enabled automatically when you set your system theme to dark and it can be updated on the fly. Until next time, see ya!",
            "image": null,
            "datetime": "2021-12-01T19:23:23"
        }
    ]
]
```
