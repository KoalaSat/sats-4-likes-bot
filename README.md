[![Codacy Badge](https://app.codacy.com/project/badge/Grade/db3100f978a542d588f8ae9a4abf2d55)](https://www.codacy.com/gh/KoalaSat/sats-4-likes-bot/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=KoalaSat/sats-4-likes-bot&amp;utm_campaign=Badge_Grade)
[![MIT license](https://img.shields.io/badge/license-MIT-green)](https://github.com/KoalaSat/sats-4-likes-bot/blob/main/LICENSE)

# Sats 4 Likes Bot

This app is an automatic tasker and claimer for https://www.sats4likes.com. It has been build by reverse-engineering the app so it can review the list of tasks and automatically interact with the specific service API to complete the requested task. Once it's done, it claims to sats4likes the reward.

## Getting Started

Go to `./app/init.rb`. Those are the tokens you need for running the app.

I could have note down here a detailed description about how to obtain each of them, but where is the fun? Go and earn those sats :)

## Running

### Manual

You can manually trigger a complete check of tasks on your machine.

```
bundle install
bundle exec rake run
```

### Docker

The app is ready to be triggered every 25 hours by a cronjob on a docker instance.

```
docker-compose up -d
```

## Some Features to Work On

- [ ] ~~Integrationm with YouTube service~~ (YouTube blocks sats4likes app)
- [ ] Detect when a task is done before claiming it to the API
- [ ] Persist invalid tasks so they are not claimed again
- [ ] Integration with a node to claim channel requests 

------

Made with 🐨 by https://github.com/koalasat
