![banner](https://raw.githubusercontent.com/RobinBoers/nindo-phx/master/priv/static/images/banner.png)

<p align="center"><a href="LICENSE"><img src="https://img.shields.io/github/license/RobinBoers/nindo-phx"></a> <img src="https://img.shields.io/github/commit-activity/w/RobinBoers/nindo-phx?color=success"> <a href="https://github.com/RobinBoers/nindo-phx/stargazers"> <img src="https://img.shields.io/github/stars/RobinBoers/nindo-phx?color=yellow"></a> <a href="https://github.com/RobinBoers/nindo-phx/fork"><img src="https://img.shields.io/github/forks/RobinBoers/nindo-phx?color=blueviolet"></a></p>

# Overview

Nindo is a RSS reader and blogging platform designed to be easy and minimal.

![intro](https://raw.githubusercontent.com/RobinBoers/nindo-phx/master/priv/static/images/post.png)

## Features

- Markdown support
- Comments
- Dark mode
- Readable
- RSS feeds
- REST API
- Responsive and quick

## Resources

- [About](https://docs.geheimesite.nl/nindo-phx/about.html)
- [Usage](https://docs.geheimesite.nl/nindo-phx/content.html)
- [Self-hosting](https://docs.geheimesite.nl/nindo-phx/getting-started.html)
- [API Documentation](https://docs.geheimesite.nl/nindo-phx/rest-api.html)

## To Do

Steps necessary to make Nindo a stable platform:

- Render posts in LiveComponent instead of seperate LiveView to remove the need to cache them seperately.
- Update to the newest LiveView version and replace the current node stuff with esbuild?
- Write full test-suite (ugghh)
- Update ex_doc (because newer version has nicer docs & dark mode)
- Add PubSub for live updating the timeline

Read more about why we need to do this here: [The current state of Nindo](https://nindo.geheimesite.nl/post/24).
