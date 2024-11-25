---
layout: doc
---

# Get started

## What is Ruku?

Ruku is a **rust** based tiny PaaS. It allows you to do git push deployments to your own servers. It was inspired by [Piku](https://piku.github.io/), [Dokku](https://dokku.com) and [Kamal](https://kamal-deploy.org).

It's still in early stages of development, so expect breaking changes. But it's already usable. It runs on a single
linux server of your choice. It's not a cloud service, it's a self-hosted PaaS. Why not use the cloud? Becuase you can 😎.

It uses [Nixpacks](https://nixpacks.com) under the hood to build your application.

## System requirements

- A linux server with a public IP address. You can use a VPS or a cloud server.
- Atleast 1GB of RAM.
- Root access to the server.

## Installation

```bash [Terminal]
curl https://rukulab.github.io/get.sh | sh
```

> Run this command as the root user on your linux server to get started.

## Usage

After installation, you can use the `ruku` command to deploy your application.
