# NindoPhx

Nindo is a small-scale self-hosted opensource social media platform. Its key features are security, ease of use and reliabilty. It is designed by Robin Boers and built using Phoenix Framework and Elixir.

Nindo was first built as a small chatting platform for a local community in Maassluis. It's codebase was pretty terrrible and very insecure. This newer version of Nindo is fully rewritten in Elixir and much more stable and secure than the original. The old Nindo archive can be found on my [personal website](https://www.geheimesite.nl/library/projects/package/nindo.php). It is full of cool old stuff.

Some people ask why I called it Nindo. Well, the anwser is is: I liked Ninjas when I built the original version and I still like the name. Did you know it was originally called DGAW when it was in the first alpha stages? I know, a terrible name :)

## Features

- Posts with images
- Construct your own feed
- No AI nonsense
- Every user's post are exported in an RSS feed

## TODOs

- Add way to upload images
- Add way to follow people (and include in home feed)
- Favicons feeds
- Post posts via web client
- Way faster RSS parsing (maybe something built in another lang and wrapped for use in erlang/elixir)
- RSS optimizing

## Questions

- Is it OK to get content from other sites and using it as safe? (And what else?)
- Nindo.Format.display_name/1 defined in application :nindo is used by the current application but the current application does not depend on :nindo. If :nindo is a dependency, make sure it is listed under "def deps" in your mix.exs
- Is the way I created the components correct?
- Why are classes generated in EEx not picked up by tailwind?
- How to encrypt email in DB that is easy to decrypt for me, but hard for attacker?

## Credits

Nindo is built using a lot of great tools. I want to especially thank [Elixir](https://elixir-lang.org), [Phoenix Framework](https://www.phoenixframework.org), [bcrypt_elixir](https://github.com/riverrun/bcrypt_elixir), [feeder_ex](https://github.com/manukall/feeder_ex), and [elixir-rss](https://github.com/BennyHallett/elixir-rss).
