class Current < ActiveSupport::CurrentAttributes
  attribute :session

  def account
    session&.account
  end

  def user
    account if account.is_a?(User)
  end

  def admin
    account if account.is_a?(Admin)
  end
end