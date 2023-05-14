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
