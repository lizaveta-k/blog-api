# frozen_string_literal: true

class Seeds
  IP_COUNT = 50
  USER_COUNT = 100
  POST_COUNT = 200_000
  RATED_POST_COUNT = 1000
  RATING_COUNT = 10

  def self.run
    new.run
  end

  def run
    ActiveRecord::Base.transaction do
      ips = create_ips
      logins = create_logins

      create_posts(ips, logins)
      create_ratings
    end
  end

  private

  def create_ips
    (1..IP_COUNT).map { |i| "ip#{i}" }
  end

  def create_logins
    (1..USER_COUNT).map { |i| "user#{i}" }
  end

  def create_posts(ips, logins)
    bar = create_bar('Posts', POST_COUNT)

    POST_COUNT.times do |i|
      result = CreatePost.run(
        title: "Seed Post #{i}",
        content: "Seed content #{i}.",
        ip: ips.sample,
        login: logins.sample
      )

      error('Post', result[:error]) if result[:error]

      bar.increment
    end
  end

  def create_ratings
    bar = create_bar('Rating', RATED_POST_COUNT)

    Post.limit(RATED_POST_COUNT).find_each do |post|
      RATING_COUNT.times do
        result = CreateRating.run(
          value: rand(1..5),
          post_id: post.id
        )

        error('Rating', result[:error]) if result[:error]
      end

      bar.increment
    end
  end

  def error(record, errors)
    Rails.logger.error("Failed to create #{record}: #{errors}")
    raise ActiveRecord::Rollback
  end

  def create_bar(title, total)
    ProgressBar.create(
      format: '%t %e %P% Processed: %c from %C',
      total: total, title: title
    )
  end
end

Seeds.run
