module ApplicationHelper
  def short_time_ago_in_words(from_time)
    distance_in_seconds = (Time.now - from_time).round

    case distance_in_seconds
    when 0..59
      "#{distance_in_seconds}s ago"
    when 60..3599
      "#{(distance_in_seconds / 60).round}m ago"
    when 3600..86399
      "#{(distance_in_seconds / 3600).round}h ago"
    when 86400..604799
      "#{(distance_in_seconds / 86400).round}d ago"
    when 604800..4838399
      "#{(distance_in_seconds / 604800).round}w ago"
    else
      "#{(distance_in_seconds / 2592000).round}mo ago"
    end
  end
end
