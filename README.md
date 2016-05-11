RuBot!<img src="app/assets/images/rubot_profile_pic.png" alt="RuBot logo" width= "250"/>
======

An expirement in onboarding for the Udacity Rubyists Slack team! If desired, RuBot can be cloned, customized, and deployed to suit the needs of your Slack team. 

See [RuBot's UI](https://rubot.udacity.com/).

## What does the bot do?

1. **Messages**

  Schedule messages to be sent to new Slack team members based on how long they have been a member. For example, one message could immediately welcome the user and offering an orientation while another is scheduled to offer 1:1 appointments 5 days later.

  The goal is to schedule messages at strategic intervals in hopes of increasing engagement and retention.

2. **Interactions**

  Set user input, or trigger words, and a response. The bot will respond whenever somebody sends the trigger word to it.

    ![Alt text](https://github.com/udacity/RuBot/blob/master/app/assets/images/rubotspeak.png)

3. **Blasts**

  Send a direct message from the bot to every user on your team.

4. **Etc.**

  The UI also contains information about every user on your team and some metrics about bot usage.

  See [RuBot's UI](https://rubot.udacity.com/)


## Customize the bot for your own team.

RuBot is a Rails app built to be (somewhat) easily reproduced and customized. To work on the application, you will need to have Ruby, Rails, and Postgres installed. If you want to deploy to berlioz you will also need to have docker installed and a dockerhub account. You will need to email steven.worley@udacity.com for more information.

To set up your own custom version of RuBot, follow these instructions:

1. **Create your bot user on Slack**

  You'll need Slack admin priveledges to do this. Visit this link: [Create bot user](https://my.slack.com/services/new/bot)

  Follow the setup instructions. You don't need to set anything except for the name and upload an image.

  Copy the API token and keep in a safe place.

2. **Clone the repository**

  `git clone https://github.com/udacity/RuBot.git`

3. **Create a branch for your bot**

  Your branch name should be your bot name. Ex for Rubot: `git checkout -b rubot`. It will serve as your master branch. Please DO NOT PUSH TO MASTER, unless you've made a change that should propagate to all bots.

4. **Set ENV variables**

  Testing: Create a file named `application.yml` in the project root directory containing the following text:

    ```
    SLACK_TOKEN: "<put your testing team token here>"
    CLIENT_ID: "<your google oauth client id>"
    CLIENT_SECRET: "<your google oauth client secret>"
    REGISTRAR_PW: "<your registrar key"
    SEGMENT_WRITE_KEY: "your segment key"
    ```

  Production: Go to https://circleci.com/gh/udacity/rubot/edit#env-vars and set your ENV vars with the following format:

    ```
    YOURBOTNAME_SLACK_TOKEN
    YOURBOTNAME_CLIENT_ID
    YOURBOTNAME_CLIENT_SECRET
    ```

    Replacing YOURBOTNAME with your bot's name, which is the same as your branch name.

5. **Create branch for Circle CI**

  Open `circle.yml` and add the following to the bottom of the file:

    ```
    deployment:
      yourbotname:
        branch: "yourbotname"
        commands:
          - ./deploy.rb
    ```
    replacing yourbotname with your bot's name.

6. **Customize**

    In `/config/application.rb` set the following variables to fit your needs:
    ```
    Rails.application.config.client_name =
    Rails.application.config.ndkey =
    Rails.application.config.standard_responses =
    ```

    Replace `rubot_profile_pic.png` in `/app/assets/images/` with your bot's logo. Be sure to leave the file name the same OR change the image tags throughout the project. 

## Deployment instructions

When you push to your bot's branch, it will automatically build and deploy through CircleCI! If you want to push to your branch without deploying include `[ci skip]` in the commit message.

## Known issues

None currently.

## Contributors

Contributors include Fuzz Worley, Colt Steele, and Angel Perez.
