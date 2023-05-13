# # use ruby 3.2.0 alpine as base image. Alpine is used to reduce the image size

# # Alpine images are typically smaller and lighter in weight because they don't have most of the unused packages and dependencies other images come with. 
# # Making use of these images as a base helps reduce the size of Docker images. 
# # This results in faster download speeds when deploying.
# FROM ruby:3.2.0-alpine AS builder

# # install dependencies
# # apk is the package manager for Alpine Linux. Non-Alpine Linux distributions use apt-get or yum to install packages.
# RUN apk add \
#   build-base \
#   postgresql-dev 
  
# COPY Gemfile* .

# RUN bundle install

# FROM ruby:3.2.0-alpine AS runner

# RUN apk add \
#   tzdata \
#   nodejs \
#   postgresql-dev

# WORKDIR /app

# # copy the gems from the builder stage to the runner stage
# COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
# COPY . .

# EXPOSE 3000

# CMD ["rails", "server", "-b", "0.0.0.0"]

# build with docker build -t <image_name> .
# run with docker run -p 3000:3000 <image_name>

FROM ruby:3.2.0
RUN apt-get update && apt-get install -y nodejs
WORKDIR /app
COPY Gemfile* .
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]