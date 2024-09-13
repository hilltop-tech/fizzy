module BubblesHelper
  BUBBLE_ROTATION = %w[ 90 80 75 60 45 35 25 5 -45 -40 -75 ]
  BUBBLE_SIZE = [ 14, 16, 18, 20, 22 ]
  MIN_THRESHOLD = 7

  def bubble_rotation(bubble)
    value = BUBBLE_ROTATION[Zlib.crc32(bubble.to_param) % BUBBLE_ROTATION.size]

    "--bubble-rotate: #{value}deg;"
  end

  def bubble_size(bubble)
    total = MIN_THRESHOLD + bubble.boosts.size + bubble.comments.size
    value = BUBBLE_SIZE.min_by { |size| (size - total).abs }

    "--bubble-size: #{value}cqi;"
  end

  def render_comments_and_boosts(bubble)
    combined_collection = (bubble.comments + bubble.boosts).sort_by(&:updated_at)
    safe_join([
      render_creator_summary(bubble, combined_collection),
      render_remaining_items(combined_collection)
    ])
  end

  private
    def render_creator_summary(bubble, combined_collection)
      content_tag(:div, class: "comment--upvotes flex-inline align-start gap fill-white border-radius center position-relative") do
        summary = "Added by #{bubble.creator.name} #{time_ago_in_words(bubble.created_at)} ago"
        summary += render_initial_boosts(combined_collection) if combined_collection.first.is_a?(Boost)
        summary.html_safe
      end
    end

    def render_initial_boosts(combined_collection)
      grouped_boosts = []
      combined_collection.each do |item|
        break unless item.is_a?(Boost)
        grouped_boosts << item
      end

      if grouped_boosts.any?
        user_boosts = grouped_boosts.group_by(&:creator).transform_values(&:count)
        boost_summaries = user_boosts.map { |user, count| "#{user.name} +#{count}" }
        ", #{boost_summaries.to_sentence}"
      else
        ""
      end
    end

    def render_remaining_items(combined_collection)
      grouped_boosts = []
      safe_join(combined_collection.drop(initial_boosts_count(combined_collection)).map do |item|
        if item.is_a?(Boost)
          grouped_boosts << item
          next if combined_collection[combined_collection.index(item) + 1].is_a?(Boost)
          render_grouped_boosts(grouped_boosts.dup).tap { grouped_boosts.clear }
        else
          render partial: "comments/comment", object: item
        end
      end.compact)
    end

    def render_grouped_boosts(boosts)
      return if boosts.empty?
      user_boosts = boosts.group_by(&:creator).transform_values(&:count)
      boost_summaries = user_boosts.map { |user, count| "#{user.name} +#{count}" }
      content_tag(:div, class: "comment--upvotes flex-inline align-start gap fill-white border-radius center position-relative") do
        boost_summaries.to_sentence.html_safe
      end
    end

    def initial_boosts_count(combined_collection)
      combined_collection.take_while { |item| item.is_a?(Boost) }.count
    end
end
