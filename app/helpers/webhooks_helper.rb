module WebhooksHelper
  def webhook_action_options(actions = Webhook::PERMITTED_ACTIONS)
    actions.map do |action|
      [ action, I18n.t("webhooks.action_labels.#{action}") ]
    end
  end

  def webhook_action_label(action)
    I18n.t("webhooks.action_labels.#{action}", default: action.to_s.humanize)
  end

  def link_to_webhooks(board, &)
    link_to board_webhooks_path(board_id: board),
        class: [ "btn", { "btn--reversed": board.webhooks.any? } ],
        data: { controller: "tooltip", bridge__overflow_menu_target: "item", bridge_title: I18n.t("webhooks.index.title") } do
      icon_tag("world") + tag.span(I18n.t("webhooks.index.title"), class: "for-screen-reader")
    end
  end
end
