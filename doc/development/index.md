# Development

## Introduction
This is the development documentation that developers should keep an eye on it when onboarding on the project and during the whole developement phase ;)

## Workflow

1. [How to squash commits](https://github.com/wprig/wprig/wiki/How-to-squash-commits)

## Setup
Please follow the steps below to setup the project in development mode.

### Documentation

1. Read documentation

1. Write documentation:
    - with [Sublime Text](https://www.sublimetext.com/) you can use [Markdown Preview](https://facelessuser.github.io/MarkdownPreview/usage/)

1. Update documentation

### Docker

#### Introduction

The docker initialization was covered in the [Installation > Introduction](../installation/index.md) section.

#### Setup

1. Before starting, [install Compose](https://docs.docker.com/compose/install/).


1. Clone the repository:

    ```
    git clone https://github.com/sebco/admin-reputation-ruby-docker.git
    ```

1. Once you do that, navigate to the directory you've cloned:

    ```
    cd admin-reputation-ruby-docker
    ```

    **Note:** All the next steps assume that you are in the project directory.

1. Copy `.env.example` to `.env`:

    ```
    cp .env.example .env
    ```

1. Run the docker-compose command to build and start all containers using the script :

    ```
    docker-compose up --build
    ```

    **Note:** Beware, each time this command is used a newer image will be created but old images will still be present so to clean up all that stuff use `docker image prune`.

1. You can check that everything went well, in another terminal (in the project directory of course) just run:

    ```
    docker-compose ps
    ```

    Output:

    ```
                         Name                                    Command               State               Ports
    -------------------------------------------------------------------------------------------------------------------------
    admin-reputation-ruby-docker_admin-reputation_1   /bin/sh -c bundle exec uni ...   Up      0.0.0.0:8010->8010/tcp
    admin-reputation-ruby-docker_nginx_1              /docker-entrypoint.sh ngin ...   Up      80/tcp, 0.0.0.0:8042->8042/tcp
    admin-reputation-ruby-docker_postgres_1           docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp
    ```

1. Finally, you need to create the database:

    ```
    docker-compose run --user "1000:1000" admin-reputation rake db:reset
    docker-compose run --user "1000:1000" admin-reputation rake db:migrate
    ```

    **Note:** you can now use `docker-compose exec admin-reputation bash` to navigate inside the admin-reputation container.

1. That’s it. Head over to `http://localhost:8042` to see the the welcome page.

1. To stop the application, run:

    ```
    docker-compose down
    ```

1. To restart the application (if you haven't modified any config variables), run:

    ```
    docker-compose up
    ```

    **Note:** You can learn more [here](https://docs.docker.com/compose/reference/up/).

1. Write code following the project guidelines and ROR best practices (please ;)

1. Good luck and have fun !
