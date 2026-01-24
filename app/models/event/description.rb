class Event::Description
  include ActionView::Helpers::TagHelper
  include ERB::Util

  attr_reader :event, :user

  def initialize(event, user)
    @event = event
    @user = user
  end

  def to_html
    to_sentence(creator_tag, card_title_tag).html_safe
  end

  def to_plain_text
    to_sentence(creator_name, quoted(card.title))
  end

  private
    def to_sentence(creator, card_title)
      if event.action.comment_created?
        comment_sentence(creator, card_title)
      else
        action_sentence(creator, card_title)
      end
    end

    def creator_tag
      tag.span data: { creator_id: event.creator.id } do
        tag.span(I18n.t("events.description.you"), data: { only_visible_to_you: true }) +
        tag.span(event.creator.name, data: { only_visible_to_others: true })
      end
    end

    def card_title_tag
      tag.span card.title, class: "txt-underline"
    end

    def creator_name
      h(event.creator.name)
    end

    def quoted(text)
      %("#{h text}")
    end

    def card
      @card ||= event.action.comment_created? ? event.eventable.card : event.eventable
    end

    def comment_sentence(creator, card_title)
      I18n.t("events.description.commented_on", creator: creator, card_title: card_title).html_safe
    end

    def action_sentence(creator, card_title)
      case event.action
      when "card_assigned"
        assigned_sentence(creator, card_title)
      when "card_unassigned"
        unassigned_sentence(creator, card_title)
      when "card_published"
        I18n.t("events.description.added", creator: creator, card_title: card_title).html_safe
      when "card_closed"
        I18n.t("events.description.moved_to_done", creator: creator, card_title: card_title).html_safe
      when "card_reopened"
        I18n.t("events.description.reopened", creator: creator, card_title: card_title).html_safe
      when "card_postponed"
        I18n.t("events.description.moved_to_not_now", creator: creator, card_title: card_title).html_safe
      when "card_auto_postponed"
        I18n.t("events.description.auto_moved_to_not_now", card_title: card_title).html_safe
      when "card_resumed"
        I18n.t("events.description.resumed", creator: creator, card_title: card_title).html_safe
      when "card_title_changed"
        renamed_sentence(creator, card_title)
      when "card_board_changed", "card_collection_changed"
        moved_sentence(creator, card_title)
      when "card_triaged"
        triaged_sentence(creator, card_title)
      when "card_sent_back_to_triage"
        I18n.t("events.description.moved_back_to_maybe", creator: creator, card_title: card_title).html_safe
      end
    end

    def assigned_sentence(creator, card_title)
      if event.assignees.include?(user)
        I18n.t("events.description.will_handle", creator: creator, card_title: card_title).html_safe
      else
        assignees_text = h(event.assignees.pluck(:name).to_sentence)
        I18n.t("events.description.assigned_to", creator: creator, assignees: assignees_text, card_title: card_title).html_safe
      end
    end

    def unassigned_sentence(creator, card_title)
      assignees_text = event.assignees.include?(user) ? I18n.t("events.description.yourself") : event.assignees.pluck(:name).to_sentence
      I18n.t("events.description.unassigned_from", creator: creator, assignees: h(assignees_text), card_title: card_title).html_safe
    end

    def renamed_sentence(creator, card_title)
      old_title = event.particulars.dig("particulars", "old_title")
      I18n.t("events.description.renamed", creator: creator, card_title: card_title, old_title: h(old_title)).html_safe
    end

    def moved_sentence(creator, card_title)
      new_location = event.particulars.dig("particulars", "new_board") || event.particulars.dig("particulars", "new_collection")
      I18n.t("events.description.moved_to", creator: creator, card_title: card_title, location: h(new_location)).html_safe
    end

    def triaged_sentence(creator, card_title)
      column = event.particulars.dig("particulars", "column")
      I18n.t("events.description.moved_to", creator: creator, card_title: card_title, location: h(column)).html_safe
    end
end
