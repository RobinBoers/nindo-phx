# List accounts

Used to get a list of user profiles.

**URL** : `/accounts`

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
    {
        "id": 87,
        "username": "epicgamercavia",
        "display_name": "Sean Hamburger",
        "profile_picture": "https://www.dieza.nl/media/catalog/product/cache/65687834e1ddad6c01a7fc58f4ccb4ea/f/e/feestdagen_pakket_hamster_2_2.jpg",
        "description": "Hello this is Neil Ciceriega aka Lemon Demon I'm on my side account because i got locked out of my main account. can you please give me your credit card information so i can buy a new microphone and continue making music. ",
        "feeds": [],
        "following": []
    },
    {
        "id": 22,
        "username": "x",
        "display_name": "hecker",
        "profile_picture": "https://m.media-amazon.com/images/I/61+HWT+vnzL._AC_UL1000_.jpg",
        "description": "\"It is a fairly open secret that almost all systems can be hacked, somehow. It is a less spoken of secret that such hacking has actually gone quite mainstream.\"",
        "feeds": [],
        "following": []
    }
]
```
