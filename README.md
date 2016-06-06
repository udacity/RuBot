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

4. **Data!**

  The application is configured to send data to Segment and integrate with Chartio automatically!

5. **Etc.**

  The UI also contains information about every user on your team and some metrics about bot usage.

  See [RuBot's UI](https://rubot.udacity.com/)


## Customize the bot for your own team.

RuBot is a Rails app built to be (somewhat) easily reproduced and customized. To set up your own custom version of RuBot, follow these instructions:

1. **Create your bot user on Slack**

  You'll need Slack admin priveledges to do this. Visit this link: [Create bot user](https://my.slack.com/services/new/bot)

  Follow the setup instructions. You don't need to set anything except for the name and upload an image.

  Copy the API token and keep in a safe place.

2. **Obtain Google Oauth credentials**

  Visit: https://console.developers.google.com/ and get a client_id and client_secret from the Google+ API to use for authentication OR you can use my keys if you want to skip this step.

  Setup your Authorized redirect URIs using this format:
  https://yourbotname.udacity.com/admins/auth/google_oauth2/callback

  replacing yourbotname with your bot's name.

3. **Clone the repository**

  `git clone https://github.com/udacity/RuBot.git`

4. **Create a branch for your bot**

  Your branch name should be your bot name. Ex: `git checkout -b yourbotname`. It will serve as your master branch. Please DO NOT PUSH TO MASTER, unless you've made a change that should propagate to all bots.

5. **Set ENV variables**

  Testing: Create a file named `application.yml` in the project root directory containing the following text:

    ```
    SLACK_TOKEN: "<put your testing team token here>"
    CLIENT_ID: "<your google oauth client id>"
    CLIENT_SECRET: "<your google oauth client secret>"
    ```

  Production: Go to https://circleci.com/gh/udacity/rubot/edit#env-vars and set your ENV vars with the following format:
    ```
    YOURBOTNAME_SLACK_TOKEN
    YOURBOTNAME_CLIENT_ID
    YOURBOTNAME_CLIENT_SECRET
    YOURBOTNAME_SECRET_KEY_BASE
    ```
    To get `YOURBOTNAME_SECRET_KEY_BASE` token, navigate to your project's root directory in terminal, and execute this command: `RAILS_ENV=production rake secret`. You will need to have Rails installed for this command to work. If you don't have Rails installed and don't want to install it, ping @fuzz, and I can get this key for you.

6. **Create branch for Circle CI**

  Open `circle.yml` and add the following to the bottom of the file:

    ```
      yourbotname:
        branch: "yourbotname"
        commands:
          - ./deploy.rb
    ```
    replacing yourbotname with your bot's name.

7. **Customize**

    In `/config/application.rb` set the following variables to fit your needs:
    ```
    Rails.application.config.client_name =
    Rails.application.config.ndkey =
    Rails.application.config.standard_responses =
    ```

    Replace `rubot_profile_pic.png` in `/app/assets/images/` with your bot's logo. Be sure to leave the file name the same OR change the image tags throughout the project. 

## Deployment instructions

When you push to your bot's branch, it will automatically build and deploy through CircleCI! If you want to push to your branch without deploying include `[ci skip]` in the commit message.

## Analytics

The program is already setup to be tracking your teams metrics via segment / chartio integration. You will however need to invite your bot user into each channel that you want to run analytics on.

Your teams separating factor is the `ndkey` value in the tracks and indentifies sent to segment. This is automatically configured in the Customize step above.

## Contributors

Contributors include Fuzz Worley, Colt Steele, and Angel Perez.
