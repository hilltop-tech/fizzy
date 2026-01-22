module CommentsHelper
  def new_comment_placeholder(card)
    if card.creator == Current.user && card.comments.empty?
      t("cards.new.description_placeholder")
    else
      t("cards.comments.new.placeholder")
    end
  end
end
